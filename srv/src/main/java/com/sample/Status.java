package com.sample;

public enum Status {
    IN_PROCESS("In Process"),
    ACCEPTED("Accepted"),
    REJECTED("Rejected");

    private final String text;

    Status(final String text) {
        this.text = text;
    }

    @Override
    public String toString() {
        return text;
    }
}
