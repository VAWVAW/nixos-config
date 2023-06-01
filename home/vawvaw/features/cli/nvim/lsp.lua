local lspconfig = require("lspconfig")

-- python
lspconfig.pyright.setup {}

-- rust
lspconfig.rust_analyzer.setup {
--   settings = {
--     ['rust-analyzer'] = {
--       cargo = {
--         sysrootSrc = "/nix/store/rn2ry1xyg2mg7axdi6xbwnidlha24i7h-rust-lib-src"
--       }
--     }
--   }
}
