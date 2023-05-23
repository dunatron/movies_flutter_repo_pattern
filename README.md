# movies_repository_pattern

## Getting Started

## Clean Architecture

Each layer should have a clear responsibility and be decoupled from the others in order to reduce complexity and probability of failure and improving maintainability

## linting

the flutter linting has been commented out and the lint package has been installed instead by running `flutter pub add --dev lint` and found in the `analysis_options.yaml` file.  
To ensure the configuration is correct you can run `flutter analyze` in the root of your project

## environment setup

## Data layer

- use [quick type](https://app.quicktype.io/) to help generate API models

## Repository

A repository is a crucial component that is responsible for managing data while hiding its technical details from the rest of the layers. It enables the other layers to perform data selection, insertion, deletion etc

The repository may use one or more data sources to work with, such as a remote API or a local database. Its responsibility is to decide how to manage data using these sources effectively. The repository acts as a mediator between the data sources and the other layers, abstracting them from the complexity of the data sources and providing a simplified interface for interacting with the data

## Build models

`flutter pub run build_runner build --delete-conflicting-outputs`

## Packages

`build_runner`: `flutter pub add --dev build_runner`

`Freezed`: used to duplicate objects and use comparison methods as this is missing from dart `flutter pub add freezed_annotation` and `flutter pub add --dev freezed`

`logger`: to log when things go wrong `flutter pub add logger`

`dio`: A rest client to make network requests with `flutter pub add dio`

`json_serializable`: auto generate response mapping code from json. `flutter pub add json_annotation` and the dev dependency `flutter pub add --dev json_serializable`

`provider`: To maintain the state of the application and obtain a reference to the repository `flutter pub add provider`. We could use a different solution such as DI with getIt or another state management library

`cached_network_image`: download and cache network images `flutter pub add cached_network_image`

`infinite_scroll_pagination`: infinite scrolling pagination list `flutter pub add infinite_scroll_pagination`

`local cache`: add sqflite and path provider for local database cache `flutter pub add sqflite path path_provider`
