@echo off
set PATH=C:\Program Files\Mozilla Firefox;%PATH%
cls
echo ######################################
echo .:WARMUP:.
echo ######################################
call mvn clean compile test-compile
cls
echo ######################################
echo .:DEMO:.
echo ######################################
echo Press a key to start the demo
pause
cls
echo ######################################
echo .:RUN WITH A CORRECT AUTHZ MATRIX:.
echo ######################################
call mvn -DCAUSE_EXPLICIT_AUTHZ_IMPL_ERRORS=false verify
pause
cls
echo ######################################
echo .:RUN WITH A INCORRECT AUTHZ MATRIX:.
echo ######################################
call mvn -DCAUSE_EXPLICIT_AUTHZ_IMPL_ERRORS=true verify
pause
cls
echo ######################################
echo .:AUTHZ MATRIX HTML REPRESENTATION:.
echo ######################################
firefox.exe file:///%CD%/authorization-matrix.xml
pause
cls
echo ######################################
echo .:TEST RESULTS:.
echo ######################################
rem See https://stackoverflow.com/a/23958874/451455 for explanation about mvn call chaining
rem Convert .xml reports into .html report, but without the CSS or images
call mvn -Dfailsafe.report.title="Authz Matrix Test Report" surefire-report:failsafe-report-only 
rem Put the CSS and images where they need to be without the rest of the time-consuming stuff
call mvn site -DgenerateReports=false
firefox.exe file:///%CD%/target/site/failsafe-report.html
