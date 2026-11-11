# EN4594 report

The report is 11 pages including the University of Moratuwa cover: EN4594 — Autonomous Systems, Semester 07, Kuruppuarachchi K.A.R.R. Edit the submission date and cover details in metadata.tex.

The report explains a 3D EKF through inline MATLAB snippets, presents simulations first, then evaluates ten recorded-flight references. It includes four simulation scenarios with 100 trials each and 30 flight windows with 20 paired noise draws and two fixed q settings: 1,200 local replay runs. Every flight/window is reported, including failures.

Four original MATLAB PNGs illustrate the turn, outage, Belevingsvlucht replay and Texas replay. Expanded numerical benchmarks are identified as local evaluations; additional MATLAB Online execution is not claimed.

All narrative, equations, tables and MATLAB snippets are in main.tex. There is no abstract, contents page, reference section or separate code appendix.

Compile from this directory:

```sh
mkdir -p build
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
```

The build produces build/main.pdf. The published report is ../output/pdf/EN4594_EKF_Aircraft_Tracking_Report.pdf. Active source requires main.tex, metadata.tex, University_of_Moratuwa_logo.png and the four matlab_*.png files in figures/. Historical drafts and build intermediates are excluded from the GitHub selection.
