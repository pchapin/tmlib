
import java.util.TreeMap;

/**
 * This class encapsulates the credential graph. It provides method for
 * adding and accessing graph nodes. Notice that in this program, it is
 * not necessary to manage the graph's edges. That information is stored
 * with the credentials in the CredentialStore.
 */
public class Graph {

    private TreeMap<String, Node> map = new TreeMap<String, Node>();

    /**
     * Add a node to the graph.
     *
     * @param incoming The name (role expression) of the node to add.
     *
     * @return A reference to an existing node if there was one; or else
     * a reference to a new (empty) node for the incoming name.
     */
    public Node addNode(String incoming)
    {
        Node n;
        if ((n = map.get(incoming)) != null) {
            return n;
        }
        n = new Node(incoming);
        map.put(incoming, n);
        return n;
    }

    /**
     * Lookup a node in the graph.
     *
     * @param name The name (role expression) of the node to lookup.
     *
     * @return A reference to an existing node or null if there is no
     * such node in the graph.
     */
    public Node getNode(String name)
    {
        return map.get(name);
    }

}

