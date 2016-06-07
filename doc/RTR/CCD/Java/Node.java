
import java.util.Iterator;
import java.util.ArrayList;

/**
 * This class encapsulates a node of the credential graph. Each node is
 * named by the role expression it represents. Each node contains a
 * collection of aggregated risk records (ARRs).
 */
public class Node implements Iterable<ARR> {
    private String name;
    private ArrayList<ARR> arrList;

    /**
     * Construct a node.
     *
     * @param nodeName A string representation of the role expression to
     * which the node corresponds.
     */
    public Node(String nodeName)
    {
        name    = nodeName;
        arrList = new ArrayList<ARR>();
    }

    /**
     * Adds an ARR to the node. If an identical ARR is already in the
     * node, there is no change. Otherwise the new ARR is added to the
     * node.
     *
     * @param incoming The new ARR.
     *
     * @return True if the node's collection of ARRs is modified in some
     * way.
     */
    public boolean addArr(ARR incoming)
    {
        boolean foundCopy = false;
        for (ARR arr : this) {
            if (arr.credentialKey == incoming.credentialKey        &&
                arr.roleOfInterest.equals(incoming.roleOfInterest) &&
                arr.totalRisk.same(incoming.totalRisk)             &&
                arr.localRisk.same(incoming.localRisk)) {

                foundCopy = true;
            }
        }
        if (!foundCopy) {
            arrList.add(incoming);
        }
        return !foundCopy;

        /* This version terminates even when maximum risk is infinite
           and the credential graph contains cycles (even zero weight
           cycles). It is also necessary (I think) to make sure "extra"
           credentials are not added to CredentialStore in this case.
           That is handled in CredentialStore.add().
           ==========================================================

        boolean modified = false;
        boolean foundComparable = false;

        for (ARR arr : this) {
            if (arr.credentialKey == incoming.credentialKey &&
                arr.roleOfInterest.equals(incoming.roleOfInterest)) {
                if (incoming.totalRisk.isComparable(arr.totalRisk) &&
                    incoming.localRisk.isComparable(arr.localRisk)) {

                    foundComparable = true;
                    if (! arr.totalRisk.po(incoming.totalRisk)) {
                        arr.totalRisk = incoming.totalRisk;
                        modified = true;
                    }
                    if (! arr.localRisk.po(incoming.localRisk)) {
                        arr.localRisk = incoming.localRisk;
                        modified = true;
                    }
                }
            }
        }
        if (!foundComparable) {
            arrList.add(incoming);
            modified = true;
        }
        return modified;
        */
    }

    /**
     * Return an iterator that allows iterators over a node's ARRs. This
     * allows a node to be treated as a collection of ARRs.
     */
    public Iterator<ARR> iterator()
    {
        return arrList.iterator();
    }

    /**
     * Convert a node to a string.
     *
     * @return The textual representation of the role expression for the
     * node.
     */
    public String toString()
    {
        return name;
    }

}

