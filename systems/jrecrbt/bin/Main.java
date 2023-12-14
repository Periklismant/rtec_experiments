

public class TuPrologEngineTester {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			// Modified for ICLP.
			System.out.println("Starting...");
			System.out.println(System.getProperty("user.dir"));
			TuPrologRecEngine engine = new TuPrologRecEngine(new NoGroupingStrategy());
			// Set model here.
			String modelPath = Files.readString(Paths.get("/home/periklis/Desktop/KR21_experiments/my_jREC/src/test/resources/model.txt"));
			System.out.println(modelPath);
			engine.setModel(modelPath);
			//engine.setModel("initially(f).\ninitiates(a,f,_).\nterminates(b,f,_).");

			//trace.addHappenedEvent("b",2);
			BufferedReader inputEventsFile;
			String input_name = "voting-8000-1-jrec";
			inputEventsFile = new BufferedReader(new FileReader("/home/periklis/Desktop/KR21_experiments/my_jREC/src/test/resources/" + input_name + ".txt"));
			FileWriter writeFile = new FileWriter("./" + input_name + "-results.txt");
			String line = inputEventsFile.readLine();
			System.out.println(engine.start());
			RecTrace trace = new RecTrace(true);
			int counter=0;
			int window_size=10;
			int stack_overflow_threshold=1000;
			//int stack_overflow_threshold=790; // 1000
			//int stack_overflow_threshold=1585; // 2000
			//int stack_overflow_threshold=3171; // 4000
			//int stack_overflow_threshold=6343; // 8000
			List rectimes= new ArrayList();
			int total_recognition_time=0;
			int window_recognition_time=0;
			while (line != null && line!="\n"){
				String[] splitted = line.split("\\s+");
				String event = splitted[0];
				int timestamp = Integer.parseInt(splitted[1]);
				trace.addHappenedEvent(event, timestamp);
				counter+=1;
				//System.out.println(counter);
				if (counter%window_size==0) {
					//System.out.println("Counter: " + Integer.toString(counter));
					engine.evaluateTrace(trace);
					long my_recognition_time = engine.getStats();
					//rectimes.add(my_recognition_time);
					//System.out.println("Recognition Time: " + Long.toString(my_recognition_time));
					window_recognition_time+=my_recognition_time;
					//System.out.println("Recognition Time: " + Long.toString(engine.getStats()));
					System.out.println(counter);
				}
				if (counter%stack_overflow_threshold==0) {
					writeFile.write(String.valueOf(engine.evaluateTrace(trace)));
					long my_recognition_time = engine.getStats();
					//rectimes.add(my_recognition_time);
					window_recognition_time+=my_recognition_time;
					rectimes.add(window_recognition_time);
					total_recognition_time+=window_recognition_time;
					System.out.println("Window Recognition Time: " + Long.toString(window_recognition_time));
					window_recognition_time=0;
					//System.out.println("About to shutdown...");
					engine.shutDown();
					//System.out.println("About to restart....");
					engine.start();
					//System.out.println("About to re-init trace...");
					trace = new RecTrace(true);
				}
				line = inputEventsFile.readLine();

			}
			inputEventsFile.close();
			//Test Example
			//trace.addHappenedEvent("exec(move(rob,room1,room2))", 1);
			//trace.addHappenedEvent("exec(move(rob,room2,room3))", 5);
			System.out.println(engine.evaluateTrace(trace));
			System.out.println(rectimes);
			System.out.println(total_recognition_time);

			writeFile.write(String.valueOf(rectimes));
			writeFile.write("\n");
			writeFile.write(String.valueOf(total_recognition_time));
			writeFile.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}