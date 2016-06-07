
import java.util.*;

/**
 * This class provides the credential database. All of its methods are
 * static so it provides a single, global object.
 */
public class CredentialStore {

    private static ArrayList<Credential> store = new ArrayList<Credential>();

    /**
     * Adds a credential to the database. This method adds the new
     * credential to the database unconditionally; even if there already
     * exists an identical credential, a new one is added.
     *
     * @param rawCredential Textual form of the credential to add or update.
     * @param type The type of the credential.
     * @param risk The risk value to use on the credential.
     */
    public static void add(String rawCredential, int type, Risk risk)
    {
        Credential newCred =
            new Credential(rawCredential, type, store.size(), risk);

        store.add(newCred);
    }

    /**
     * Lookup a credential by its key.
     *
     * @param key The credential key of the crendential of interest. The
     * key must be valid. No checking is done.
     */
    public static Credential getCredential(int key)
    {
        return store.get(key);
    }

    /**
     * Get all credentials that define a given node. A credential is
     * said to define a node if the role expression the node represents
     * is the target of the credential.
     *
     * @param N The node of interest.
     *
     * @return A list of credential references for all known credentials
     * that define the node.
     */
    public static List<Credential> getDefiningCredentials(Node N)
    {
        LinkedList<Credential> result = new LinkedList<Credential>();
        for (Credential cred : store) {
            if (cred.target().equals(N.toString())) {
                result.add(cred);
            }
        }
        return result;
    }

}
