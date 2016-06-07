
/**
 * This class encapsulates aggregated risk records (ARRs). Each such
 * record contains information about the risk accumulated from a
 * particular role of interest. ARRs are copied from node to node in the
 * credential graph. However, each ARR is initially created under the
 * control of a particular credential. The ARR remembers this for later
 * use by the observer functions.
 *
 * The fields of this class are all public; the class is intended to
 * behave like a "record".
 */
public class ARR {
    public int      credentialKey;    // Credential concerned with ROI
    public String   roleOfInterest;   // Roles only; not role expressions.
    public Risk     totalRisk;        // Risk from start of search.
    public Risk     localRisk;        // Risk from ROI.
    public Observer observerFunction; // Function to handle entities.

    /**
     * Construct a new ARR using given initial values.
     *
     * @param ck The credential key of the credential that creates the ARR.
     * @param roi The name of the role of interest.
     * @param tr The initial total risk.
     * @param lr The initial local risk (always bottom?)
     * @param of The observer function associated with this ARR.
     */
    public ARR(int ck, String roi, Risk tr, Risk lr, Observer of)
    {
        credentialKey    = ck;
        roleOfInterest   = roi;
        totalRisk        = tr;
        localRisk        = lr;
        observerFunction = of;
    }

    /**
     * Compute a new ARR that has updated aggregated risks.
     *
     * @param risk The risk value to use in the computation.
     *
     * @return A new ARR (this is not modified) that is the same as this
     * ARR except that both the total and local risk values have been
     * updated according to \oplus.
     */
    public ARR aggregate(Risk risk)
    {
        ARR newArr = new ARR(
                             credentialKey,
                             roleOfInterest,
                             totalRisk.oplus(risk),
                             localRisk.oplus(risk),
                             observerFunction);

        return newArr;
    }

    /**
     * Execute the observer function associated with this ARR.
     *
     * @param entityNode The node for the entity that has been
     * discovered. This node must represent an entity. No checking is
     * done.
     */
    public void executeObserver(Node entityNode)
    {
        observerFunction.execute(this, entityNode);
    }

    /**
     * Convert an ARR to a displayable string.
     *
     * @return A user friendly representation of the ARR. This is useful
     * for display or debugging purposes.
     */
    public String toString()
    {
        String result = new String
            ("(" + credentialKey  + ", " +
                   roleOfInterest + ", " +
                   totalRisk      + ", " +
                   localRisk      + ")");
        return result;
    }
}

