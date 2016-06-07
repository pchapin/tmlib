
import java.util.*;

/**
 * This class contains the observer function used when an entity is
 * discovered to be in a role used as part of an intersection.
 */
public class IntersectionObserver extends Observer {
    private static class MapIndex implements Comparable<MapIndex> {
        public int    credentialKey;
        public String entityName;

        public MapIndex(int key, String name)
        {
            credentialKey = key;
            entityName    = new String(name);
        }

        public int compareTo(MapIndex other)
        {
            if (credentialKey < other.credentialKey) return -1;
            if (credentialKey > other.credentialKey) return +1;
            return entityName.compareTo(other.entityName);
        }
    }

    private static class MapValue {
        public String roleName;
        public Risk   localRisk;

        public MapValue(String name, Risk local)
        {
            roleName  = new String(name);
            localRisk = local;
        }
    }

    private static TreeMap<MapIndex, ArrayList<MapValue>> intersectionMap =
        new TreeMap<MapIndex, ArrayList<MapValue>>();

    public void execute(ARR riskRecord, Node entityNode) {
        MapIndex mi =
            new MapIndex(riskRecord.credentialKey, entityNode.toString());
        ArrayList<MapValue> valueList = intersectionMap.get(mi);

        // If this is the first time this (Cred, E) seen, just add value.
        if (valueList == null) {
            valueList = new ArrayList<MapValue>();
            valueList.add
                (new MapValue
                    (riskRecord.roleOfInterest, riskRecord.localRisk));
            intersectionMap.put(mi, valueList);
            return;
        }

        // Add to or update the value list found.
        boolean found = false;
        for (MapValue value : valueList) {
            if (value.roleName.equals(riskRecord.roleOfInterest)) {
                value.localRisk = riskRecord.localRisk;
                found = true;
            }
        }
        if (!found) {
            valueList.add
                (new MapValue
                    (riskRecord.roleOfInterest, riskRecord.localRisk));
        }

        // Assume that if there are enough values in the value list, all
        // roles are accounted for. In that case, build the derived
        // credential. This assumes the originating credential only
        // initialized exactly the right number of ROIs.

        Credential c = CredentialStore.getCredential(riskRecord.credentialKey);
        if (Credential.getRoleList(c.source()).size() == valueList.size()) {
            String derivedCredential =
                new String(c.source() + " <- " + entityNode);
            Risk accumulated = new Risk(0);  // Should use bot.
            for (MapValue value : valueList) {
                accumulated = accumulated.oplus(value.localRisk);
            }
            CredentialStore.add(derivedCredential, 1, accumulated);
            Node intersectionNode = Global.G.getNode(c.source());
            Global.Q.offer(intersectionNode);
        }
    }
}
