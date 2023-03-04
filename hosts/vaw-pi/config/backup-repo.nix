{ outputs, ... }:
{
  services.borgbackup.repos.default = {
    path = "/data/backup";
    authorizedKeys = (map (name: builtins.readFile ../../${name}/ssh_host_ed25519_key.pub) (builtins.attrNames outputs.nixosConfigurations)) ++ [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfE4SmPSqUtzlIwhHIamwYVkinxYNYFZ9QPD+3/FJRpZSHHOBtKkLo3iZsHNttH75/zLaZV/ARS69FPJ3IMd+i2WTk0ZcDxOFeT71Aser+OJphyruruB6/VxCRq2eWezRI2Z1KnCh5vxpc4mNXEkFStuS/AebKB2oNG18WZJcUnamELA7WzxUBkT1aQKEhRIiIKyaEOEoF7u0RB1/0rhnOx7g+Zisj95507zhLHsHzPqJXjqYRMa3+u2k72nRUc5QTjLbc0aqKjfrjAF/24IAOjlCPs/yQWPfe6LGoRK5K7LHQnuI4+wnBCL4pyicnsMB433mNxyYYfhrX7B1A5HcMqewLYXUIb1dcmOzZK2jZVHZs831Wh+0s2hWtZYcjFDgmVne3sGK8/mYKPbgKw+9li7An05OatMSWbXsAqWawIap5JWrYlMXLRwfx764JxWaZadhlKTWvhRU2jnkMHG5MQUKt7MIMdj87fVN4rWZ6PD1MLe6VDdsEiSt/v7uwy9fFJOKJV2kdRKKZCYbUeF//aaUG89cF6sSgZTht/RL9y8W9+cqm8GoXnd/9fPfx1xsCPF2bwKVvneW4UMspHrRIHTgxqpDunsQMZ7A2C5DJW+iXnAduLw6xx6v0Qu88MCCaeThudqqYVSoWF4b27rOTJ0btw0Nwf/5wodrPghgvHQ== (none)" ];
  };
}
