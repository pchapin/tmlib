
/**
 * This class contains the observer function used when an entity is
 * discovered to be in a role used as part of a linked role.
 */
public class LinkingObserver extends Observer {

    /**
     * Processed a new member of a linked role. This method computes a
     * derived credential representing the new membership in the linked
     * role and then adds that credential to the credential store.
     */
    public void execute(ARR riskRecord, Node entityNode) {
        Credential interested =
            CredentialStore.getCredential(riskRecord.credentialKey);

        // Compute the new role name based on the entity's name.
        String newRole = new String
          (entityNode.toString() +
           "." +
           Credential.getLinkedRole(interested.source()));

        // Add new role to graph and derived credential to credential store.
        Node newNode = Global.G.addNode(newRole);
        String derivedCredential = new String
          (interested.source() + " <- " + newRole);
        CredentialStore.add(derivedCredential, 2, riskRecord.localRisk);
        Global.Q.offer(Global.G.getNode(interested.source()));
   }
}
