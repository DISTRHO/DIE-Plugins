# DIE-Plugins

This is a collection of plugins imported into the DISTRHO project for easy packaging.  
They are simply to die for ;)

DIE stands for DISTRHO Imported Effect.  
It is a play on words from the first imported plugins, "ACE", from the Ardour project.

Imported plugins have their bundle and URIs renamed, in order to make them compatible with the originals.

The current list of imported plugins so far are:

 * <b>Ardour (Community Effect)</b>  
   Reason: So you no longer need to build the entire Ardour codebase to get these plugins.

## Building

DIE-Plugins current requires the following external libraries:

 - glib2.0
 - sndfile

With those installed, one can build the source code by simply running:

```
make
```

Compiled LV2 plugins will be placed in the `bin/` directory.  
To install system-wide, you can run something like:

```
sudo make install PREFIX=/usr/local
```
