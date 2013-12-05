package org.fcrepo.test.profiles.ant;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.fcrepo.bench.BenchTool;
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

    private String action = "ingest";

    private String uri = "localhost:8080";

    private String logpath = "/tmp/bench-tool-logs";

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

    public void setAction(final String op) {
        this.action = op;
    }

    public void setThreads(final int threads) {
        this.threads = threads;
    }

    public void setLogpath(final String logpath) {
        this.logpath = logpath;
    }

    /*
     * (non-Javadoc)
     * @see org.apache.tools.ant.Task#execute()
     */
    @Override
    public void execute() throws BuildException {
        log.info("executing benchtool:");
        final HashMap<String, String> m = new HashMap<String, String>();
        m.put("-f", uri);
        m.put("-n", String.valueOf(numObjects));
        m.put("-s", String.valueOf(dataSize));
        m.put("-t", String.valueOf(threads));
        m.put("-a", action);
        m.put("-l", logpath);

        final ArrayList<String> l = new ArrayList<String>();
        for (final String e : m.keySet()) {
            l.add(e);
            l.add(m.get(e));
        }
        BenchTool.main(l.toArray(new String[] {}));
    }

}
