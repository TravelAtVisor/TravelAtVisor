# Travel@Visor Project Structure

## File structure of a Feature Module
A feature module is an isolated part of the application that has no
references to other feature modules, allthough it may have references
to the special *shared_module*.


```
example_module/
├── views/
│   ├── example_button.view.dart
│   └── example_textfield.view.dart
├── utils/
│   └── example_mapper.dart
├── pages/
│   ├── example.page.dart
│   └── another_example.page.dart
├── models/
│   ├── example.model.dart
│   └── example_enum.model.dart
├── example.dataservice.dart
└── example.navigation_service.dart

```

Navigation to other feature modules is defined via an abstract class
defined in a file called *[module_name].navigation_service.dart* . It
is implemented in the *shared_module*.

Data *manipulation* is defined in an abstract class which is defined
in *[module_name].dataservice.dart*. The corresponding implementation 
can be found in a class in the *shared_module*.

The concrete implementation of both the modules navigation- and
dataservice is made available using the provider-Package and therefore
the `BuildContext`. One will access the services using `context.read<>()`
in the `build()` method.

## File structure of the shared_module
The *shared_module* wires up the feature models. It does so by implementing
all navigation- and dataservices. Furthermore it is responsible, that all
feature modules can *read* data by providing a global *application_state*
via the provider package.

```
shared_module/
├── views/
│   ├── authentication_guard.dart
│   ├── example_button.view.dart
│   └── example_textfield.view.dart
├── utils/
│   └── dynamic_mapper.dart
├── models/
│   ├── application_state.model.dart
│   ├── current_user.model.dart
│   └── custom_user_data.model.dart
├── data_service.dart
└── navigation_service.dart
```

## Modules
* Shared-Module
  * Application State
  * Globally used custom widgets (button, textinput)
  * dynamic to class mappers for remotely sourced data
  * Data- and NavigationService implementation
* User-Module
  * Login / Register Views
  * Manage Friends
  * My Profile View
* Trip-Module
  * List Trips Page (incl. Activity Preview)
  * Create / Edit Trip Page
* Activity-Module
  * Create / Edit Activity Page
  * View Activity Page
