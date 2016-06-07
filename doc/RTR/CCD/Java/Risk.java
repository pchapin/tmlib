
/**
 * This class encapsulates risk values. In the current implementation
 * only the sum-of-costs model is supported where risk values are
 * natural numbers. A future version of this class might be abstract to
 * allow for easy replacement of the risk lattice.
 */
public class Risk {
    private int value;

    /**
     * Construct a risk from a raw value.
     *
     * @param initial The value used to create the risk. This value must
     * be greater than or equal to zero. No checking is done.
     */
    public Risk(int initial)
    {
        value = initial;
    }

    /**
     * Aggregate two risk values and returns the new risk value. This
     * method implements the \oplus operator.
     *
     * @param right The right hand side of \oplus.
     *
     * @return The risk value of this \oplus right.
     */
    public Risk oplus(Risk right)
    {
        return new Risk(value + right.value);
    }

    /**
     * Compute if two risk values are comparable. In the current
     * implementation this method always returns true.
     *
     * @param other The other risk to consider.
     *
     * @return True iff this and other are comparable.
     */
    public boolean isComparable(Risk other)
    {
        if (this.po(other) || other.po(this)) return true;
        return false;
    }

    /**
     * Compute the partial order of two risk values.
     *
     * @param right The right hand side of \po
     *
     * @return True iff this and right are comparable and this \po right
     * is true.
     */
    public boolean po(Risk right)
    {
        return value <= right.value;
    }

    /**
     * Compute if two risk values are the same.
     *
     * @param other The other risk value to consider.
     *
     * @return True iff this and other are the same.
     */
    public boolean same(Risk other)
    {
        return value == other.value;
    }

    /**
     * Convert a risk value to a string. This is useful for display and
     * debugging purposes.
     *
     * @return The string representation of this risk value.
     */
    public String toString()
    {
        return Integer.toString(value);
    }
}
