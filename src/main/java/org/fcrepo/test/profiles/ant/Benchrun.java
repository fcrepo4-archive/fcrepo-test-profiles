package org.fcrepo.test.profiles.ant;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.fcrepo.bench.BenchToolFC4;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * @author Gregory Jansen
 *
 */
public class Benchrun extends Task {

    private static final Logger log = LoggerFactory.getLogger(Benchrun.class);

    private int numObjects = 100;

    private int dataSize = 50;

    private int threads = 1;

    private String operation = "ingest";

    private String uri = "localhost:8080";

    public void setUri(final String uri) {
        this.uri = uri;
    }

    /**
     * Set the number of objects use in test
     *
     * @param x
     */
    public void setNumobjects(final int x) {
        this.numObjects = x;
    }

    /**
     * Set the size of datastreams to use in test
     *
     * @param x
     */
    public void setDatasize(final int x) {
        this.dataSize = x;
    }

    public void setOperation(final String op) {
        this.operation = op;
    }

    public void setThreads(final int threads) {
        this.threads = threads;
    }

    /*
     * (non-Javadoc)
     * @see org.apache.tools.ant.Task#execute()
     */
    @Override
    public void execute() throws BuildException {
        log.info("executing benchtool:");
        final String[] args =
                new String[] {uri, String.valueOf(numObjects),
                        String.valueOf(dataSize), String.valueOf(threads),
                        operation};
        BenchToolFC4.main(args);
    }

}
