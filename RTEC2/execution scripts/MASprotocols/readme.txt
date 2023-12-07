Execution scripts:

continuousQueries:
 - performs continuous queries, and logs the recognised intervals and some execution statistics.
 - invoke the predicate: continuousQueries(+ApplicationName, +WM, +Step, +AgentNo, +Seed).
 - look up an application name in the handleApplicationMAS file.
 - WM is working memory, Step determines query times, AgentNo is the number of agents in the scenario and Seed is used for random input generation.

run_experiments:
 - runs continuousQueries/5 for all the parameter combinations defined at the top of the file. 
 - these runs are performed sequencially, each with a different instance of YAP.