{ pkgs, lib, ... }:
let
  metals = { version, outputHash }:

    let
      metalsDeps = pkgs.stdenv.mkDerivation {
        name = "metals-deps-${version}";
        buildCommand = ''
          export COURSIER_CACHE=$(pwd)
          ${pkgs.coursier}/bin/cs fetch org.scalameta:metals_2.13:${version} \
            -r bintray:scalacenter/releases \
            -r sonatype:snapshots > deps
          mkdir -p $out/share/java
          cp -n $(< deps) $out/share/java/
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        inherit outputHash;
      };
    in pkgs.metals.overrideAttrs (old: {
      inherit version;
      extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
      buildInputs = [ metalsDeps ];
    });
  metals-pkg = metals {
    version = "1.0.1";
    outputHash = "sha256-AamUE6mr9fwjbDndQtzO2Yscu2T6zUW/DiXMYwv35YE=";
  };
in {
  programs.neovim.extraLuaConfig = lib.mkAfter ''
    local dap = require("dap")

    -- rust
    local extension_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/"
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

    require("rust-tools").setup {
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      },
      tools = {
        inlay_hints = {
          highlight = "LspInlayHints",
        },
      },
    }

    -- python
    require('dap-python').setup('${
      pkgs.python311.withPackages (ps: with ps; [ debugpy ])
    }/bin/python')

    -- scala
    metals_config = require('metals').bare_config()
    metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()
    metals_config.on_attach = function(_, bufnr)
      require("metals").setup_dap()

      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lmc', '<cmd>lua require("metals").commands()<CR>', opts)
    end

    metals_config.settings = {
      metalsBinaryPath = "${metals-pkg}/bin/metals",
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true,
      excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl"
      }
    }

    metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
          prefix = '',
        }
      }
    )

    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }

    -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
    vim.opt_global.shortmess:remove("F")

    vim.cmd([[augroup lsp]])
    vim.cmd([[autocmd!]])
    vim.cmd([[autocmd FileType java,scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
    vim.cmd([[augroup end]])
  '';
}
