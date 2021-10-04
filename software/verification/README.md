# Verifying installed control sequences using CDL

A python based open-loop verification software to test whether the control sequences installed in HVAC controllers meet the required specification.
The reference sequences to be tested must be Modelica models that conform to the [Control Description Language](https://obc.lbl.gov/specification/cdl.html) specification.

## Details

Check documentation [here](https://obc.lbl.gov/specification/verification.html).

## Setup

* pip install -r requirements.txt
* OpenModelica
  * [OpenModelica for Linux](https://www.openmodelica.org/download/download-linux)
  * [OpenModelica for Windows](https://www.openmodelica.org/download/download-windows)
  * [OpenModelica for Mac](https://www.openmodelica.org/download/download-mac)
* conda install -c plotly plotly-orca
* [modelica-json](https://github.com/lbl-srg/modelica-json)
* Ensure that the environmental variables `$MODELICAPATH` and `$MODELICAJSONPATH` are set.

## Execution

* Set up a configuration json file with the sequence to be tested and other details. Check [this](http://obc.lbl.gov/specification/verification.html#sec-ver-spe-tes-set).
* Write a file that maps the names and units of CDL points to the corresponding real controller's points and units (See [example](http://obc.lbl.gov/specification/verification.html#ver-poi-map)).

```python verify_cdl_sequence.py --config <config_filename>.json```

## Test

```python verify_cdl_sequence.py --config config_test.json```

This runs an unsuccessful test for the sequence
`Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.Validation.ZoneTemperatures`
using existing outputs from a controller. This does not require a controller to be connected to the network.
Upon completion, one chart comparing the actual output to the CDL output for each output variable will be generated in the directory `test`.
