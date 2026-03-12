---
name: screen-capture
description: Capture the current Mac screen and return the saved image path. Use when visible on-screen content must be analyzed, especially for desktop apps or browser pages whose text is not directly accessible.
---

# screen-capture

This skill captures the current screen on macOS and returns the saved PNG path.

## When to use
- Reading visible content from desktop apps
- Capturing dashboards or web apps that do not expose text
- Supporting screenshot-based visual analysis

## Output
Returns JSON like:

{"image_path":"/tmp/openclaw_screen_<timestamp>.png"}
