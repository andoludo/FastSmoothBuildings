# BESTEST (ASHRAE Standard 140)

The BESTEST validation runs in [trano](https://github.com/andoludo/trano), on the models trano generates from the YAML
descriptions of the 27 cases of ASHRAE Standard 140 with every library it supports: see
[trano's BESTEST page](https://andoludo.github.io/trano/validation/bestest/) for the cases, the acceptance bands and
the other libraries. FastSmoothBuildings gates there as Buildings and IDEAS do: `pytest -m bestest` fails when one of
its KPIs leaves its band or drifts from its frozen value. This page is the section of FastSmoothBuildings, as trano
rendered it when the library moved to this repository; the analysis of these results, now and along the history of the
library, is in [the BESTEST report of the analysis](../analysis/02_bestest.md).


The `FastSmoothBuildings` library gives trano a reduced model of the same building: the closed-loop model whose components
rumoca translates to a CasADi ODE for optimal control and calibration. It runs the same YAML files in OpenModelica.
Its walls are discretised as Buildings discretises them (`number_of_states`, at most three sublayers per layer), its
zones take the air density of the site and exchange long-wave radiation as the YAML asks (linearised at 20 degC or
around the current surface temperatures), its outer surfaces exchange with sky and ground exactly, the gas gaps of its
glazings conduct at the temperatures of their panes (long-wave exchange and convection of the gas, as Buildings), its
windows are shaded by overhangs and side fins as in Buildings, and its controllers are smooth and without events. It
gates as Buildings and IDEAS do, on the 27 cases. The column Buildings gives the frozen value of Buildings for the
same case (`expected/Buildings.json`), so that the gap between the two libraries reads next to the band. How the two
libraries compare hour by hour, and how they respond to a change of the parameters, is studied in [FastSmoothBuildings against
Buildings on BESTEST and a house before and after renovation](study.md); how FastSmoothBuildings came to these
results is told in the [improvement plan](improvement_plan.md).

105 of 105 KPIs of 27 cases are inside their band.
Against Buildings, the loads differ by 1.1 % on average and 4.4 % at most, the temperatures of the free-floating zones by 0.38 K on average and 1.70 K at most.

| Case | KPI | FastSmoothBuildings | Buildings | Band | Reference mean | Status |
|---|---|---|---|---|---|---|
| 600 | annual_heating | 4.463 MWh | 4.449 MWh | 3.750 to 4.980 | 4.213 | pass |
| 600 | annual_cooling | 6.051 MWh | 5.973 MWh | 5.000 to 6.830 | 5.856 | pass |
| 600 | peak_heating | 3.222 kW | 3.215 kW | 2.852 to 3.527 | 3.183 | pass |
| 600 | peak_cooling | 6.262 kW | 6.187 kW | 5.098 to 6.805 | 6.024 | pass |
| 610 | annual_heating | 4.489 MWh | 4.475 MWh | 3.610 to 5.270 | 4.311 | pass |
| 610 | annual_cooling | 4.864 MWh | 4.810 MWh | 2.740 to 6.030 | 4.256 | pass |
| 610 | peak_heating | 3.222 kW | 3.216 kW | 2.853 to 3.528 | 3.168 | pass |
| 610 | peak_cooling | 6.140 kW | 6.082 kW | 5.009 to 6.754 | 5.861 | pass |
| 620 | annual_heating | 4.580 MWh | 4.563 MWh | 3.670 to 5.380 | 4.413 | pass |
| 620 | annual_cooling | 4.110 MWh | 4.087 MWh | 2.760 to 5.190 | 4.090 | pass |
| 620 | peak_heating | 3.255 kW | 3.248 kW | 2.869 to 3.554 | 3.186 | pass |
| 620 | peak_cooling | 4.724 kW | 4.700 kW | 3.715 to 5.037 | 4.526 | pass |
| 630 | annual_heating | 4.771 MWh | 4.746 MWh | 3.690 to 6.120 | 4.822 | pass |
| 630 | annual_cooling | 3.328 MWh | 3.320 MWh | 1.080 to 4.420 | 2.814 | pass |
| 630 | peak_heating | 3.258 kW | 3.251 kW | 2.870 to 3.557 | 3.203 | pass |
| 630 | peak_cooling | 4.267 kW | 4.250 kW | 3.315 to 4.423 | 3.963 | pass |
| 640 | annual_heating | 2.724 MWh | 2.716 MWh | 1.580 to 3.760 | 2.612 | pass |
| 640 | annual_cooling | 5.799 MWh | 5.725 MWh | 4.440 to 6.860 | 5.636 | pass |
| 640 | peak_heating | 4.345 kW | 4.356 kW | 3.806 to 4.891 | 4.369 | pass |
| 640 | peak_cooling | 6.211 kW | 6.138 kW | 5.044 to 6.750 | 5.973 | pass |
| 650 | annual_heating | 0.000 MWh | 0.000 MWh | 0.000 to 0.000 | 0.000 | pass |
| 650 | annual_cooling | 4.871 MWh | 4.802 MWh | 3.460 to 5.880 | 4.644 | pass |
| 650 | peak_heating | 0.000 kW | 0.000 kW | 0.000 to 0.000 | 0.000 | pass |
| 650 | peak_cooling | 6.036 kW | 5.949 kW | 4.731 to 6.604 | 5.813 | pass |
| 660 | annual_heating | 3.610 MWh | 3.620 MWh | 2.680 to 4.820 | 3.713 | pass |
| 660 | annual_cooling | 3.407 MWh | 3.315 MWh | 1.910 to 4.330 | 3.172 | pass |
| 660 | peak_heating | 2.722 kW | 2.728 kW | 2.472 to 3.103 | 2.801 | pass |
| 660 | peak_cooling | 3.719 kW | 3.629 kW | 3.146 to 4.130 | 3.565 | pass |
| 670 | annual_heating | 6.632 MWh | 6.473 MWh | 4.000 to 7.960 | 5.681 | pass |
| 670 | annual_cooling | 6.223 MWh | 6.361 MWh | 5.050 to 7.670 | 6.402 | pass |
| 670 | peak_heating | 4.402 kW | 4.294 kW | 3.444 to 4.432 | 3.943 | pass |
| 670 | peak_cooling | 6.518 kW | 6.560 kW | 5.493 to 7.271 | 6.445 | pass |
| 680 | annual_heating | 2.237 MWh | 2.227 MWh | 1.210 to 3.080 | 2.056 | pass |
| 680 | annual_cooling | 6.316 MWh | 6.136 MWh | 5.130 to 7.700 | 6.264 | pass |
| 680 | peak_heating | 2.032 kW | 2.013 kW | 1.672 to 2.232 | 1.984 | pass |
| 680 | peak_cooling | 6.637 kW | 6.518 kW | 5.408 to 7.404 | 6.446 | pass |
| 685 | annual_heating | 4.945 MWh | 4.932 MWh | 4.080 to 5.750 | 4.763 | pass |
| 685 | annual_cooling | 9.030 MWh | 8.946 MWh | 7.700 to 10.140 | 8.886 | pass |
| 685 | peak_heating | 3.233 kW | 3.225 kW | 2.863 to 3.543 | 3.183 | pass |
| 685 | peak_cooling | 7.010 kW | 6.932 kW | 5.713 to 7.517 | 6.743 | pass |
| 695 | annual_heating | 2.781 MWh | 2.768 MWh | 1.700 to 3.810 | 2.656 | pass |
| 695 | annual_cooling | 8.946 MWh | 8.754 MWh | 7.490 to 10.580 | 8.912 | pass |
| 695 | peak_heating | 2.056 kW | 2.047 kW | 1.688 to 2.245 | 2.001 | pass |
| 695 | peak_cooling | 7.203 kW | 7.080 kW | 5.855 to 7.918 | 6.979 | pass |
| 900 | annual_heating | 1.712 MWh | 1.718 MWh | 1.040 to 2.280 | 1.627 | pass |
| 900 | annual_cooling | 2.440 MWh | 2.395 MWh | 2.350 to 2.600 | 2.467 | pass |
| 900 | peak_heating | 2.690 kW | 2.668 kW | 2.304 to 2.917 | 2.591 | pass |
| 900 | peak_cooling | 3.039 kW | 2.974 kW | 2.387 to 3.545 | 2.975 | pass |
| 910 | annual_heating | 1.882 MWh | 1.887 MWh | 1.560 to 2.300 | 1.971 | pass |
| 910 | annual_cooling | 1.637 MWh | 1.615 MWh | 0.860 to 2.000 | 1.374 | pass |
| 910 | peak_heating | 2.698 kW | 2.676 kW | 2.329 to 2.939 | 2.648 | pass |
| 910 | peak_cooling | 2.330 kW | 2.280 kW | 1.945 to 2.858 | 2.305 | pass |
| 920 | annual_heating | 3.348 MWh | 3.324 MWh | 2.550 to 4.200 | 3.326 | pass |
| 920 | annual_cooling | 2.693 MWh | 2.663 MWh | 2.430 to 3.080 | 2.786 | pass |
| 920 | peak_heating | 2.762 kW | 2.743 kW | 2.367 to 3.040 | 2.710 | pass |
| 920 | peak_cooling | 3.245 kW | 3.223 kW | 2.536 to 3.655 | 3.127 | pass |
| 930 | annual_heating | 3.779 MWh | 3.745 MWh | 2.750 to 5.350 | 4.064 | pass |
| 930 | annual_cooling | 2.194 MWh | 2.177 MWh | 1.240 to 2.640 | 1.898 | pass |
| 930 | peak_heating | 2.774 kW | 2.753 kW | 2.389 to 3.116 | 2.751 | pass |
| 930 | peak_cooling | 2.883 kW | 2.869 kW | 2.182 to 3.205 | 2.656 | pass |
| 940 | annual_heating | 1.096 MWh | 1.101 MWh | 0.220 to 1.910 | 1.109 | pass |
| 940 | annual_cooling | 2.370 MWh | 2.329 MWh | 2.240 to 3.140 | 2.401 | pass |
| 940 | peak_heating | 3.301 kW | 3.274 kW | 2.858 to 4.076 | 3.377 | pass |
| 940 | peak_cooling | 3.038 kW | 2.974 kW | 2.387 to 3.545 | 2.993 | pass |
| 950 | annual_heating | 0.000 MWh | 0.000 MWh | 0.000 to 0.000 | 0.000 | pass |
| 950 | annual_cooling | 0.727 MWh | 0.717 MWh | 0.430 to 1.520 | 0.634 | pass |
| 950 | peak_heating | 0.000 kW | 0.000 kW | 0.000 to 0.000 | 0.000 | pass |
| 950 | peak_cooling | 2.395 kW | 2.385 kW | 1.935 to 2.507 | 2.268 | pass |
| 960 | annual_heating | 2.575 MWh | 2.588 MWh | 2.000 to 3.400 | 2.693 | pass |
| 960 | annual_cooling | 0.928 MWh | 0.950 MWh | 0.620 to 1.810 | 0.896 | pass |
| 960 | peak_heating | 2.108 kW | 2.104 kW | 1.970 to 2.415 | 2.195 | pass |
| 960 | peak_cooling | 1.424 kW | 1.476 kW | 1.264 to 1.554 | 1.393 | pass |
| 960 | maximum_temperature | 49.050 degC | 48.036 degC | 47.100 to 54.200 | 49.920 | pass |
| 960 | minimum_temperature | 4.204 degC | 4.160 degC | 3.200 to 9.000 | 5.800 | pass |
| 960 | mean_temperature | 27.112 degC | 26.693 degC | 25.800 to 30.500 | 28.060 | pass |
| 980 | annual_heating | 0.437 MWh | 0.441 MWh | -0.610 to 1.280 | 0.407 | pass |
| 980 | annual_cooling | 3.567 MWh | 3.415 MWh | 3.520 to 4.490 | 3.710 | pass |
| 980 | peak_heating | 1.554 kW | 1.538 kW | 1.169 to 1.778 | 1.489 | pass |
| 980 | peak_cooling | 3.404 kW | 3.296 kW | 2.747 to 3.851 | 3.348 | pass |
| 985 | annual_heating | 2.376 MWh | 2.371 MWh | 1.680 to 3.090 | 2.398 | pass |
| 985 | annual_cooling | 6.211 MWh | 6.140 MWh | 5.950 to 7.260 | 6.351 | pass |
| 985 | peak_heating | 2.688 kW | 2.666 kW | 2.313 to 2.924 | 2.631 | pass |
| 985 | peak_cooling | 3.939 kW | 3.863 kW | 2.997 to 4.436 | 3.824 | pass |
| 995 | annual_heating | 0.982 MWh | 0.984 MWh | -0.150 to 2.020 | 0.974 | pass |
| 995 | annual_cooling | 6.958 MWh | 6.789 MWh | 6.580 to 8.410 | 7.145 | pass |
| 995 | peak_heating | 1.615 kW | 1.598 kW | 1.284 to 1.797 | 1.565 | pass |
| 995 | peak_cooling | 4.061 kW | 3.973 kW | 3.104 to 4.435 | 3.986 | pass |
| 600FF | maximum_temperature | 64.382 degC | 63.318 degC | 61.400 to 69.400 | 64.600 | pass |
| 600FF | minimum_temperature | -12.974 degC | -12.847 degC | -14.800 to -8.900 | -12.700 | pass |
| 600FF | mean_temperature | 24.811 degC | 24.664 degC | 23.300 to 27.100 | 25.250 | pass |
| 650FF | maximum_temperature | 63.173 degC | 62.135 degC | 60.100 to 67.800 | 63.067 | pass |
| 650FF | minimum_temperature | -16.901 degC | -16.922 degC | -18.800 to -15.700 | -17.333 | pass |
| 650FF | mean_temperature | 18.859 degC | 18.733 degC | 16.600 to 19.900 | 18.300 | pass |
| 680FF | maximum_temperature | 70.617 degC | 68.913 degC | 68.800 to 79.500 | 73.017 | pass |
| 680FF | minimum_temperature | -7.515 degC | -7.312 degC | -9.100 to -4.700 | -6.867 | pass |
| 680FF | mean_temperature | 30.546 degC | 30.137 degC | 29.200 to 34.300 | 31.850 | pass |
| 900FF | maximum_temperature | 44.071 degC | 43.840 degC | 42.300 to 47.000 | 44.583 | pass |
| 900FF | minimum_temperature | 0.977 degC | 1.107 degC | -0.400 to 3.200 | 1.250 | pass |
| 900FF | mean_temperature | 25.033 degC | 24.932 degC | 23.500 to 26.700 | 25.233 | pass |
| 950FF | maximum_temperature | 36.930 degC | 36.790 degC | 35.100 to 38.100 | 36.583 | pass |
| 950FF | minimum_temperature | -12.060 degC | -12.046 degC | -14.400 to -11.500 | -12.983 | pass |
| 950FF | mean_temperature | 15.292 degC | 15.243 degC | 13.400 to 16.000 | 14.733 | pass |
| 980FF | maximum_temperature | 49.339 degC | 48.664 degC | 47.500 to 53.800 | 50.500 | pass |
| 980FF | minimum_temperature | 9.628 degC | 9.634 degC | 6.300 to 13.500 | 10.350 | pass |
| 980FF | mean_temperature | 30.839 degC | 30.470 degC | 29.500 to 34.300 | 31.800 | pass |
