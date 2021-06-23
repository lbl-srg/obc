# Verifying installed control sequences using CDL

A python based open-loop verification software to test whether the control sequences installed in HVAC controllers meet the required specification.
The reference sequences to be tested must be present in the [Modelica Buildings Library](https://github.com/lbl-srg/modelica-buildings/) and
conform to the CDL specification.

## Details

Check documentation [here](https://obc.lbl.gov/specification/verification.html).

## Setup

* pip install -r requirements.txt
* [OpenModelica](https://www.openmodelica.org/download/download-linux)
* [OMPython](https://github.com/OpenModelica/OMPython)
* [pyfunnel](https://github.com/lbl-srg/funnel/)
* conda install -c plotly plotly-orca
* [modelica-json](https://github.com/lbl-srg/modelica-json)
* Ensure that `$MODELICAPATH` and `$MODELICAJSONPATH` environmental variables are set

## Execution

* Set up a configuration json file with the sequence to be tested and other details. Check [this](http://obc.lbl.gov/specification/verification.html#sec-ver-spe-tes-set).
* Write a file that maps the names and units of CDL points to the corresponding real controller's points and units (See [example](http://obc.lbl.gov/specification/verification.html#ver-poi-map)).

```python verify_cdl_sequence.py --config <config_filename>.json```

## Test

```python verify_cdl_sequence.py --config config_test.json```
