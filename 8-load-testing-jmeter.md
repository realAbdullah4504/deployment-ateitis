The process we are going to follow is as follows:

    When QA creates the info_server.txt file, they must also create a folder /Tests/YYYY-MM-DD/jmeter/, where they must upload the .jmx files. Then they should push or create a merge request, depending on the previously defined flow.

    The job validate_test_server_info will be executed.

    If the previous job passes, another job named validate_test_info_jmeter will be triggered. This job has the objective of validating:

        That the jmeter folder exists inside /Tests/YYYY-MM-DD/.

        That there are .jmx files inside that folder.

    If this job fails, an automatic email notification must be sent to the QA team explaining the error.
    If it passes, the next stage will start (I'll explain that to you afterwards).


🧩 Jenkins – Next Step: Automated Load Testing with JMeter (Stage 15)

Please follow these steps:

    Create a new Freestyle Project in Jenkins
    Name: Test - Prueba de carga automatizada (JMETER) - Etapa 15

    Trigger condition:
    This job must be triggered only if the job validate_test_info_jmeter passed successfully.

    Execution logic:

        The job should connect to JMeter (you can run JMeter via CLI or Docker).

        It should locate and execute all .jmx test files located in:
        /Tests/YYYY-MM-DD/jmeter/

    After executing the JMeter tests:

        Collect the test result files (typically .jtl format).

        Archive those .jtl files.

        If available, generate a test result report using JMeter's reporting feature.

    Create a results folder:

        Automatically create a folder inside /Tests/YYYY-MM-DD/jmeter/
        Format: X_RESULTADO_FECHAYHORA

            X = execution/test number

            RESULTADO = either PASS or FAIL

            FECHAYHORA = date and time of the test execution

        Inside that folder, store:

            The .jtl result files

            The report (if generated)

            Any additional artifacts collected from the run

    Notification rules:

        If the job result is FAIL, send an email notification to the QA team with relevant info.

        If the result is PASS, for now, do nothing.

📌 Important:
Make sure to document everything in Spanish, including:

    Jenkins job configuration

    Notifications

    Folder structure used

    Example of outputs if possible
