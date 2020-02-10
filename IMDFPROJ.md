# IMDFPROJ Reference
The projects created in the application are stored as a folder with the extension `.imdfproj`.
For better understanding of the folder structure this guide documents the contents and behavior
of the `.imdfproj`-Folder.

## General
The folder itself can have any valid folder name. Since the application uses a UUID to find a project
by its name (the same as for the manifest-File) it is advised to use the projects UUID for the folder
name as well.

The project folder could be named `fdbb83cd-3482-4fb8-886d-f5cf10e31bb7.imdfproj`

## Contents
The contents are pretty straightforward:
* `manifest.json`
* `overlays/`
	* `<overlay_name>.overlay/`
		* `contents.json`
		* `overlay.png`
	* `...`
* `archive.imdf/`
	* `...`

### manifest.json
The `manifest.json` describes the project and stores some metadata. The manifest is a JSON-Object
with simple key-value pairs which could look like this:
```
{
	"uuid": "fdbb83cd-3482-4fb8-886d-f5cf10e31bb7",
	"title": "Starcourt Mall, Hawkins"
	"description": "The indoor map of the Starcourt Mall in Hawkins, IN"
	"client": "Larry Kline",
	"created_at": "2020-02-10T08:00:00",
	"updated_at": "2020-02-12T15:23:12",
	"imdfproj_version": 1
}
```

* `uuid` (String) – _The unique identifier of the project. This uuid can be used to identify the project in a set of different projects_
* `title` (String) – _The display title of the project_
* `description` (String|null) – _An optional description of the project_
* `client` (String|null) – _An optional client name_
* `created_at` (ISO8601 Date) – _The datetime of the timestamp the project was created at_
* `updated_at` (ISO8601 Date) – _The datetime of the timestamp the project was last updated at_
* `imdfproj_version` (Integer) – _The version of the imdfproj-structure. When the structure of the imdfproj changes in future versions this number is used to indicate which project needs a migrate_

### Overlays
Overlays are images which are rendered between the map and the indoor mapping entities. This enables
the mapper to place footprint images which can be used as guidelines to create the units, kiosks and
other features. Overlays are stored in the `Overlays/` subfolder.

Each overlay has an own folder in the `Overlays/` subfolder with a UUID for the unique name and the
`.overlay` extension. An example could be `0cb2afad-f767-4b8a-9ce2-c246d1930614.overlay/`. In this folder are two files
which describe the overlay. A `content.json` with metadata and the raw image file named `overlay.png`.
__Important: Only PNG-Files are supported for overlays!__

The `content.json` for the overlay describes where exactly the overlay is placed and how to transform
it in the renderer which could look like this:
```
{
	"uuid": "0cb2afad-f767-4b8a-9ce2-c246d1930614",
	"title": "Level 2 Footprint",
	"anchor": [
		33.960946,
		-84.125951
	]
	"scale": 1.9,
	"angle": 24
}
```

* `uuid` (String) – _The unique identifier of the overlay. This uuid can be used to identify the overlay in a set of different overlays_
* `title` (String) – _The display title of the overlay_
* `anchor` (Array<Double>) – _An array of two double values (coordinates) of the anchor where the overlay is placed on the map_
* `scale` (Double) – _A scale used to enlarge or reduce the size of the overlay_
* `angle` (Integer) – _An angle used to rotate the overlay (360 equals 0 and 370 equals 10)_

### Archive
The `archive.imdf/` folder is used to place all files for the _Indoor Mapping Data Format_. These
files conform to the [specification of the IMDF](https://register.apple.com/resources/imdf/).
