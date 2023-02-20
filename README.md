# formigas_flutter_lints



# What is this?

This repo contains custom linter rules for dart/flutter projects.

## Add to your project

1. Add the following to your `analysis_options.yaml` file:
```yaml
analyzer:
  plugins:
    - custom_lint
```
1. Add the following to your `pubspec.yaml` file:
```yaml

dev_dependencies:
  custom_lint: <current_version>
  formigas_flutter_lints:
    path: <path to this repo>
```

## Run the lints

The plugin is relatively new. Therefore you need to run the lints with the following command:

```bash
flutter pub run custom_lint
```
