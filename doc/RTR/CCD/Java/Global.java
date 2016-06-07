
import java.util.LinkedList;
import java.util.Queue;

/**
 * This class contains objects that are intended to be globally
 * accessible. Typically this means the objects are needed in both the
 * main loop and in the observer functions.
 */
public class Global {
    public static Queue<Node> Q = new LinkedList<Node>();
    public static Graph G = new Graph();
}
