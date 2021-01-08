# Case study used in the OBC journal paper (2021)

This case study is identical to `case_study_1_oct` except that
the variables logged in the mat file were filtered to reduce their number by a factor 10. This reduces the computation time by 20% and the mat file size by a factor 5.

```bash
(base) ~/gitrepo/obc/examples[issue75_caseStudy_VAVSmallOffice_ang]$ tree -h case_study_*oct* -P '*mat'
case_study_1_oct
├── [4.0K]  img
└── [4.0K]  simulations
    ├── [4.0K]  annual_base
    │   └── [7.8G]  Buildings_Examples_VAVReheat_ASHRAE2006_result.mat
    └── [4.0K]  annual_g36
        └── [ 15G]  Buildings_Examples_VAVReheat_Guideline36_result.mat
case_study_ang_1_oct_light
├── [4.0K]  img
└── [4.0K]  simulations
    ├── [4.0K]  annual_base
    │   └── [915M]  Buildings_Examples_VAVReheat_ASHRAE2006_result.mat
    └── [4.0K]  annual_g36
        └── [3.2G]  Buildings_Examples_VAVReheat_Guideline36_result.mat
```
