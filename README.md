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

Add the following to your `yazi.toml`

```
[plugin]
prepend_preloaders = [
  # 3d objects
  { url = "*.{3mf,obj,pts,ply,stl,step,stp}", run="f3d-preview"},
]

prepend_previewers = [
  # 3d objects
  { url = "*.{3mf,obj,pts,ply,stl,step,stp}", run="f3d-preview"},
]
```

Or alternative toml syntax:

```
[[plugin.prepend_previewers]]
url = "*.{3mf,obj,pts,ply,stl,step,stp}"
run = "f3d-preview"

[[plugin.prepend_preloaders]]
url = "*.{3mf,obj,pts,ply,stl,step,stp}"
run = "f3d-preview"
```
