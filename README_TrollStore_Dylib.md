# TG Marker Cleaner dylib（TrollStore 注入）

本仓库提供 `substrate_replace_tg_marked.xm`，会将命中以下内容的字符串替换为单个空格：

- `TG@macked_chat`
- `TG@macked_channel`

## 编译为可注入 `.dylib`

```bash
./build_trollstore_dylib.sh /path/to/iPhoneOS.sdk
```

产物路径：

- `build/libTGMarkerCleaner.dylib`

> 脚本默认编译 `arm64`、最低 iOS 14.0，并链接 Foundation。

## 签名（示例）

```bash
ldid -S build/libTGMarkerCleaner.dylib
```

签名后即可用于支持 TrollStore 的注入工具流程。
