
import java.util.ArrayList;
import java.util.List;

/**
 * This class is used to represent credentials. It also provides some
 * static methods for manipulating credential strings. Note that
 * credentials are, essentially, the edges in the credential graph.
 */
public class Credential {

    private int    myType;   // Credential type.
    private int    myKey;    // Credential's key in the credential store.
    private Risk   myRisk;   // Risk associated with credential.
    private String raw;      // Textual representation of credential.

    /**
     * Construct a new credential. In a future version of this program,
     * the constructor may deduce the type of the credential from its
     * syntactic form. The type is provided here only to simplify the
     * implementation.
     *
     * @param rawForm The textual form of the credential.
     * @param type An integer representing the credntial's type.
     * @param key The key used by the credential store.
     * @param risk The risk value on the credential.
     */
    public Credential(String rawForm, int type, int key, Risk risk)
    {
        raw    = rawForm;
        myType = type;
        myKey  = key;
        myRisk = risk;
    }

    /**
     * Return the base part of a linked role name. For example the base
     * part of "A.s.t" is "A.s".
     *
     * @param linkedName The full name of the linked role ("A.s.t").
     * This method assumes an appropriate format; no checking is done.
     *
     * @return The base part of the given linked role.
     */
    public static String getBaseRole(String linkedName)
    {
        int index;

        index = linkedName.lastIndexOf('.');
        return linkedName.substring(0, index).trim();
    }

    /**
     * Return the linked part of a linked role name. For example the
     * linked part of "A.s.t" is "t".
     *
     * @param linkedName The full name of the linked role ("A.s.t").
     * This method assumes an appropriate format; no checking is done.
     *
     * @return The linked part of the given linked role.
     */
    public static String getLinkedRole(String linkedName)
    {
        int index;

        index = linkedName.lastIndexOf('.');
        return linkedName.substring(index + 1).trim();
    }

    /**
     * Return a list of role that are participating in an intersection.
     * For example, given "B.s ^ C.t" this method returns "B.s", "C.t".
     *
     * @param intersectionName The textual representation of an
     * intersection role expression.
     *
     * @return A list of role names in text form.
     */
    public static List<String> getRoleList(String intersectionName)
    {
        ArrayList<String> result = new ArrayList<String>();
        String[] rawResult = intersectionName.trim().split("\\s*\\^\\s*");

        for (String value : rawResult) {
            result.add(value);
        }
        return result;
    }

    /**
     * Return an integer representation of the credential's type.
     */
    public int type()
    {
        return myType;
    }

    /**
     * Return a string representation of the role expression on the
     * right side of the credential. For example, in A.r <- B.s, the
     * "source" part of the credential is "B.s".
     */
    public String source()
    {
        int index;

        if ((index = raw.indexOf("<-")) != -1) {
            String e = raw.substring(index + 2).trim();
            return e;
        }
        return null;
    }

    /**
     * Return a string representation of the role expression on the
     * left side of the credential. For example, in A.r <- B.s, the
     * "target" part of the credential is "A.r".
     */
    public String target()
    {
        int index;

        if ((index = raw.indexOf("<-")) != -1) {
            String e = raw.substring(0, index).trim();
            return e;
        }
        return null;
    }

    /**
     * Return the risk on the credential.
     */
    public Risk risk()
    {
        return myRisk;
    }

    /**
     * Update the risk in this credential. This is used when derived
     * credentials are modified.
     *
     * @param newRisk The new risk to use to replace the existing risk.
     */
    public void updateRisk(Risk newRisk)
    {
        myRisk = newRisk;
    }

    /**
     * Return this credential's key.
     */
    public int key()
    {
        return myKey;
    }

    /**
     * Compare two credentials. Two credentials are the same if they
     * have the same source and target role expressions. The risks on
     * the credentials are not considered in this comparison.
     */
    public boolean same(Credential other)
    {
        if (raw.equals(other.raw)) return true;
        return false;
    }
}

