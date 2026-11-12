# UNKNXWN Studios

A local-first, zero-subscription AI television production workstation.

## Project status

Foundation stage. This repository is the standalone studio project; it is separate from the UNKNXWN Base44 application.

## Goals

- Windows-first setup with a guided installer and launcher.
- Local inference and media processing wherever practical.
- No required paid APIs, subscriptions, or usage-credit services.
- Script-to-shot planning, reusable character bibles, scene generation, and episode assembly.
- Explicit capability checks before downloading large models or starting GPU workloads.

## Hardware expectations

The application must detect available GPU, VRAM, system RAM, disk space, and installed runtimes. It must never assume a particular GPU model or silently download multi-gigabyte model files. Users choose model packs after seeing storage and VRAM requirements.

## Development principles

1. Build a reliable, testable production pipeline before polishing the interface.
2. Separate planning, generation, asset management, and editing into replaceable modules.
3. Keep generated media and model weights outside the source repository.
4. Provide CPU fallback for lightweight tasks; clearly label GPU-only features.
5. Never claim a render succeeded unless the output file exists and passes validation.

## Initial milestones

- [ ] M001: Windows environment diagnostic and project bootstrap.
- [ ] M002: Character bible and asset registry.
- [ ] M003: Script breakdown into scenes and shots.
- [ ] M004: Local image/video backend adapters.
- [ ] M005: Timeline assembly and export.
- [ ] M006: One-click installer and desktop launcher.
