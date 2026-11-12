# M001: Production architecture and bootstrap plan

## Runtime layout

- `apps/desktop`: Windows desktop shell and production UI.
- `apps/worker`: local job runner for generation and media tasks.
- `packages/project-schema`: versioned project, character, scene, and shot schemas.
- `packages/media-pipeline`: validation, metadata, proxy, and export utilities.
- `docs/`: setup, compatibility, and production workflow documentation.

The initial implementation should keep the UI and worker loosely coupled. The UI submits typed jobs; the worker reports progress and returns validated artifact paths. This allows a failed render to be retried without losing the project.

## M001 acceptance criteria

1. A first-run diagnostic reports OS version, CPU, RAM, GPU name, available VRAM when detectable, disk space, and required runtime status.
2. The diagnostic is read-only. It must not install software or download model weights without explicit user action.
3. A project can be created locally with a stable project ID and folders for scripts, characters, locations, shots, audio, renders, and exports.
4. The app records task status as queued, running, succeeded, failed, or cancelled.
5. A task marked succeeded must point to an existing output file that passes a basic readability check.
6. Errors include a human-readable explanation and a retry action.

## Hardware and model policy

Do not hard-code the previously discussed RTX 5060 as a guaranteed configuration. Detect the actual GPU and VRAM at runtime. Model adapters must publish minimum and recommended requirements before installation. Model downloads are opt-in, resumable where supported, and stored outside the repository.

## Character continuity data

Each character record should support:
- stable character ID and display name
- approved reference images
- appearance description and prohibited drift notes
- wardrobe variants
- voice profile and pronunciation notes
- continuity snapshots per episode

A prompt alone is not a continuity system. The pipeline should preserve reference assets and record which references and settings were used for each generated shot.

## Production workflow

1. Import or write a script.
2. Break it into scenes and shots.
3. Attach character, location, wardrobe, and prop references.
4. Generate a shot plan and approve it.
5. Submit shots to a selected local backend.
6. Review outputs and regenerate individual shots.
7. Assemble approved shots with dialogue, sound, and music.
8. Export an episode and a manifest of source assets.

## Safety and reliability

- Never overwrite original source media.
- Use temporary output names, then atomically promote validated files.
- Keep logs local and redact secrets.
- Show disk-space estimates before model downloads or renders.
- Distinguish software installation from model-weight downloads.
- Do not promise fully local text-to-video until a compatible backend is installed and tested on the target machine.

## Next implementation slice

Implement the diagnostic and local project bootstrap first. Do not begin with an all-in-one AI model download: that creates a fragile installer, consumes substantial bandwidth, and hides compatibility failures.
