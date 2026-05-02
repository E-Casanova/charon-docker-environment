# Charon Docker Environment 🐋

A ready-to-use, containerized environment for running [Charon](https://github.com/tcadsoftware/charon) (TCAD software) and [Gmsh](https://gmsh.info/), complete with a custom Python utility to convert meshes to the Exodus format.

Charon is a powerful tool, but setup can be complex. This repository makes it "plug-and-play" for students and researchers.

## Prerequisites
* [Docker](https://docs.docker.com/get-docker/) must be installed on your host machine.
* An x86_64 cpu (Intel or Amd)

## Getting Started

### 1. Build the Image
Clone this repository and pull the Docker image
```bash
docker pull drplant1/charon:latest
```

### 2. Run the Simulation Environment

Navigate to the folder on your computer containing your simulation files (e.g., your `.py` or `.input` files) and run:

```bash
docker run -it --rm -v $(pwd):/workspace -w /workspace drplant1/charon:latest bash
```

## 🧰 Using the Mesh Converter

Once inside the running container, you can convert your meshes using the included Python utility:

```bash
python3 convert.py input_mesh.msh output_mesh.exo
```

## ⚠️ Compatibility Note

This image was compiled for **x86_64 (Intel/AMD)** architectures.