import alice.tuprolog.Prolog;
import alice.tuprolog.Theory;
import alice.tuprolog.SolveInfo;
import java.io.FileInputStream;
import java.io.File;


public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			System.out.println("Starting...");
			System.out.println(System.getProperty("user.dir"));
            Prolog p = new Prolog();
            
            String rec_variant=args[0];
            String events_no=args[1];
            String app=args[2];

            System.out.println(rec_variant);
            System.out.println(events_no);

            String modelPathStr = "../programs/" + app + "_" + events_no + "_" + rec_variant + ".pl";

            //Theory recTheory = new Theory(Main.class.getResourceAsStream(modelPathStr));
		    Theory recTheory = new Theory(new FileInputStream(new File(modelPathStr)));	

            System.out.println("Theory created.");

            long before = System.currentTimeMillis();
            p.addTheory(recTheory);

            System.out.println("Theory loaded");

            p.solve("start.");

            System.out.println("Engine started successfully");

            //SolveInfo solveInfo = p.solve("test(X).");
            SolveInfo solveInfo = p.solve("test.");
            p.solve("reset.");
            long after = System.currentTimeMillis();

            //System.out.println("Experiment ended with flag: " + Boolean.toString(ok));
            System.out.println("Experiment ended with solve info: ");
            System.out.println(solveInfo);

            System.out.println("Execution Time: " + Long.toString(after-before));


            System.out.println("Reset OK.");
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}
