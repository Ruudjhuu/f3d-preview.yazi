# f3d-preview.yazi

Yazi previewer which uses f3d to render 3d object files like: step, stl, obj, 3mf, ply and many more.

![screenshot](img/screenshot.png)

## Requirements

- f3d

## Installation

```
ya pkg add "ruudjhuu/f3d-preview"
```

## Configuration

Add the follwing to your `yazi.toml`

```

prepend_preloaders = [
  # 3d objects
  { name = "*.3mf", run = "f3d-preview" },
  { name = "*.obj", run = "f3d-preview" },
  { name = "*.pts", run = "f3d-preview" },
  { name = "*.ply", run = "f3d-preview" },
  { name = "*.stl", run = "f3d-preview" },
  { name = "*.step", run = "f3d-preview" },
  { name = "*.stp", run = "f3d-preview" },
]

prepend_previewers = [
  # 3d objects
  { name = "*.3mf", run = "f3d-preview" },
  { name = "*.obj", run = "f3d-preview" },
  { name = "*.pts", run = "f3d-preview" },
  { name = "*.ply", run = "f3d-preview" },
  { name = "*.stl", run = "f3d-preview" },
  { name = "*.step", run = "f3d-preview" },
  { name = "*.stp", run = "f3d-preview" },
]
```
