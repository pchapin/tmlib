
/**
 * This class contains the observer function used when an entity is
 * discovered to be a member of the governing role.
 */
public class GoverningObserver extends Observer {
    public void execute(ARR riskRecord, Node entityNode) {
        System.out.print
            ("(" + entityNode + ", " + riskRecord.totalRisk + ")\n");
    }
}
