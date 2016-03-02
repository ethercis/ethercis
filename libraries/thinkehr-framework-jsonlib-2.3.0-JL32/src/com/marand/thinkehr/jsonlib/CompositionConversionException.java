package com.marand.thinkehr.jsonlib;

/**
 * An exception thrown if something goes wrong while performing conversion from a Composition to another representation (such as a Map), or
 * vice-versa.
 *
 * @author matijak
 * @since 09.02.2016
 */
public class CompositionConversionException extends RuntimeException {

    public CompositionConversionException() {
    }

    public CompositionConversionException(String message) {
        super(message);
    }

    public CompositionConversionException(String message, Throwable cause) {
        super(message, cause);
    }

    public CompositionConversionException(Throwable cause) {
        super(cause);
    }

    public CompositionConversionException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
