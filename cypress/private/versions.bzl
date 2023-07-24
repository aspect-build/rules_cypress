"""Integrity hashes for cypress versions"""

# Use /scripts/mirror_release.sh to add a newer version below.
# Versions should be descending order so TOOL_VERSIONS.keys()[0] is the latest version.
TOOL_VERSIONS = {
    "12.12.0": {
        "darwin-x64": "53ddd917112a2c5c3c22d12f5bcffda596474c7cd0932a997e575b2b97ae36c0",
        "darwin-arm64": "2daadfe4431a98f9dc6442c155239aaed2746b12a59721424e3b5fdaaf27c766",
        "linux-x64": "18bf251f683e0b0ca70918c2a51b7a457be6e5298be52203bd16d4e0eb361837",
        "linux-arm64": "1f754c912eb719d4ac4abe31f3cc6d5b65cf08e0266cf6808f376c099928c88e",
        "win32-x64": "ffc47314ce5f74888066bc4a15ee18d375ee9680f9cca1b94eda7293e1dea4e5",
    },
    "12.3.0": {
        "darwin-x64": "beae3678dd859ce89cc45c377eef97b67558ee1f2a0079e9b4c824260ef3801a",
        "darwin-arm64": "bb08f247110dda9b180d2552a661b8669441f931b0332d818c306a14e8c7071a",
        "linux-x64": "57dd85936373e6ce2ae5378f9035a3ad118899341e0c6e71783c3e58c039ce92",
        "linux-arm64": "47c1188506b11644a332ab0949eab0b33179a64e4857e561d3c836c6f6f2cadf",
        "win32-x64": "639a0e0ca5498fc5330064c3fa441c741e6b6cd01234bfa9851de9a33f4f56a6",
    },
    "10.8.0": {
        "darwin-x64": "17dc620ec7e2cb06a205fd1a8a831b3b48ff8223fd5761af257152661d1d9baf",
        "darwin-arm64": "013cced7e5c1082d22346139e94be33f0ce84483843f038c464df4afa74743f9",
        "linux-x64": "8cf4a7665b54f2eb5f36ac461841c67152d7f0015c21dda3b9867bf0bc625afd",
        "linux-arm64": "a1521b1be05fdf3a0f0c008f759789a3d037f3123a1a6ad0f3c0a37308bf4901",
        "win32-x64": "f0061a5dfcbec48158f99cfcf8253ee9b912d98325bafa21bbebe8e46e98144d",
    },
}
