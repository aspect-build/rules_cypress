"""Integrity hashes for cypress versions"""

# Use /scripts/mirror_release.sh to add a newer version below.
# Versions should be descending order so TOOL_VERSIONS.keys()[0] is the latest version.
TOOL_VERSIONS = {
    "13.3.1": {
        "darwin-x64": "417c5f1d77e15c8aef0a55f155c16c3dbbc637f918c1e51f8fec6eb1c73a9ba9",
        "darwin-arm64": "143d905779c0b0a8a9049b0eb68b4b156db3d838d4546ce5082a8f7bd5dc5232",
        "linux-x64": "bb0ddd980bd82792a477b1c39ce8a0a7b275481031c559c065c94f1131151b0c",
        "linux-arm64": "fbca9958e2a153f3f1ffdef1bb506db65401a8586229b9d9424cd16228d0353d",
        "win32-x64": "acf1e478634e4da254bd7c3695d9032010c2ed17955e7339e1ea7d79cf8c9f7b",
    },
    "12.12.0": {
        "darwin-x64": "53ddd917112a2c5c3c22d12f5bcffda596474c7cd0932a997e575b2b97ae36c0",
        "darwin-arm64": "2daadfe4431a98f9dc6442c155239aaed2746b12a59721424e3b5fdaaf27c766",
        "linux-x64": "7f41d45da094380cc0d6716c8357b60f9c9304c2475cf502ea60649f040d52ad",
        "linux-arm64": "55531b5ba8d03a979a5ef92981d27964583897c652eec3788f24ec8677d05dd2",
        "win32-x64": "ffc47314ce5f74888066bc4a15ee18d375ee9680f9cca1b94eda7293e1dea4e5",
    },
    "12.3.0": {
        "darwin-x64": "beae3678dd859ce89cc45c377eef97b67558ee1f2a0079e9b4c824260ef3801a",
        "darwin-arm64": "bb08f247110dda9b180d2552a661b8669441f931b0332d818c306a14e8c7071a",
        "linux-x64": "3a300d6c903a8f5fced488183dcc7faa06e9df14c946d6dab4b5822ec738e9cd",
        "linux-arm64": "501671011a63fd450b87e1cae1b3ba3fabccf37e9c1c8c26e1d5f189f9afe688",
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
