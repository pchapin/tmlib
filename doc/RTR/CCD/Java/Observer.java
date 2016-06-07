
/**
 * This class is an abstract base class for encapsulating the "observer"
 * methods. Each ARR contains a reference to an observer object and
 * executes a method in that object whenever the ARR is copied to an
 * entity.
 */
public abstract class Observer {

    /**
     * Perform operations when an entity is discovered.
     *
     * @param riskRecord The ARR containing this observer.
     *
     * @param entityNode The entity that was discovered and that caused
     * this observer to fire.
     */
    abstract public void execute(ARR riskRecord, Node entityNode);
}
