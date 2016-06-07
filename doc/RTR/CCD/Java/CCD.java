
import java.io.*;
import java.util.*;

/**
 * This is the main class of the program. It reads the input and
 * contains the main processing loop.
 */
class CCD {

    private static       String governingRole;
    private static final Risk bot = new Risk(0);
    private static       Risk maximumRisk = new Risk(100);

    private static void readCredentials(String fileName)
    {
        try {
            BufferedReader myInput =
                new BufferedReader(new FileReader(fileName));

            boolean first = true;
            String line;
            while ((line = myInput.readLine()) != null) {

                // Preprocess lines to remove comments and extra blanks.
                int index = line.indexOf('#');
                if (index != -1) line = line.substring(0, index);
                line = line.trim();
                if (line.length() == 0) continue;

                // Deal with the other lines. (Minimal error handling for now).
                if (first) {
                    index = line.indexOf(',');
                    governingRole = line.substring(0, index).trim();
                    maximumRisk = new Risk
                        (Integer.parseInt(line.substring(index + 1).trim()));
                    first = false;
                }
                else {
                    index = line.indexOf(',');
                    String rawCredential = line.substring(0, index).trim();
                    int end_index = line.indexOf(',', index + 1);
                    int type = Integer.parseInt
                        (line.substring(index + 1, end_index).trim());
                    int risk = Integer.parseInt
                        (line.substring(end_index + 1).trim());
                    CredentialStore.add(rawCredential, type, new Risk(risk));
                }
            }
            myInput.close();
        }
        catch (FileNotFoundException e) {
            System.out.println("File not found while reading credentials.");
        }
        catch (IOException e) {
            System.out.println("IO error while reading credentials.");
        }
    }

    // Main algorithm
    // ==============

    public static void main(String[] argv) {

        // Check command line.
        if (argv.length != 1) {
            System.out.println("Error: Expecting file name on command line.");
            System.exit(1);
        }

        // Get problem from input file.
        readCredentials(argv[0]);

        // Initialize.
        Node initialNode = Global.G.addNode(governingRole);
        ARR initialArr = new ARR
            (-1, governingRole, bot, bot, new GoverningObserver());
        initialNode.addArr(initialArr);
        Global.Q.offer(initialNode);

        // Main looop.
        Node N;
        while ((N = Global.Q.poll()) != null) {
            // System.out.println("Processing node: " + N);
            
            for (Credential c : CredentialStore.getDefiningCredentials(N)) {
                switch (c.type()) {

                case 1: { // "A.r <- E"
                    Node newNode = Global.G.addNode(c.source());
                    for (ARR arr : N) {
                        boolean modified = false;
                        ARR newArr = arr.aggregate(c.risk());
                        if (newArr.totalRisk.po(maximumRisk)) {
                            modified = newNode.addArr(newArr);
                        }
                        if (modified) {
                            newArr.executeObserver(newNode);
                        }
                    }
                    break;
                } // End-of-case

                case 2: { // "A.r <- B.s"
                    Node newNode = Global.G.addNode(c.source());
                    boolean modified = false;
                    for (ARR arr : N) {
                        ARR newArr = arr.aggregate(c.risk());
                        if (newArr.totalRisk.po(maximumRisk)) {
                            modified = newNode.addArr(newArr);
                        }
                    }
                    if (modified) {
                        Global.Q.offer(newNode);
                    }
                    break;
                } // End-of-case

                case 3: {// <"A.r <- A.s.t">
                    Node newNode = Global.G.addNode(c.source());
                    for (ARR arr : N) {
                        ARR newArr = arr.aggregate(c.risk());
                        if (newArr.totalRisk.po(maximumRisk)) {
                            newNode.addArr(newArr);
                        }
                    }

                    // A.s is a node of interest. Create and initialize it.
                    Node supportNode = Global.G.addNode
                        (Credential.getBaseRole(c.source()));
                    boolean modified = false;
                    for (ARR arr : newNode) {
                        ARR supportArr = new ARR
                            (c.key(),
                             Credential.getBaseRole(c.source()),
                             arr.totalRisk,
                             bot,
                             new LinkingObserver());
                        modified = supportNode.addArr(supportArr);
                    }
                    if (modified) {
                        Global.Q.offer(supportNode);
                    }
                    break;
                } // End-of-case

                case 4: { // "A.r <- intersect(B.s1, B.s2, ..., B.sn)"
                    Node newNode = Global.G.addNode(c.source());
                    for (ARR arr : N) {
                        ARR newArr = arr.aggregate(c.risk());
                        if (newArr.totalRisk.po(maximumRisk)) {
                            newNode.addArr(newArr);
                        }
                    }

                    // Each role in the intersection is a role of interest.
                    for (String roleName : Credential.getRoleList(c.source())) {
                        Node supportNode = Global.G.addNode(roleName);
                        boolean modified = false;
                        for (ARR arr : newNode) {
                            ARR supportArr = new ARR
                                (c.key(),
                                 roleName,
                                 arr.totalRisk,
                                 bot,
                                 new IntersectionObserver());
                            modified = supportNode.addArr(supportArr);
                        }
                        if (modified) {
                            Global.Q.offer(supportNode);
                        }
                    }
                    break;
                } // End-of-case
                } // End-of-switch
            } // End-of-for (defining credentials)
        } // End-of-while (queue is not empty)
    } // End-of-main

}
