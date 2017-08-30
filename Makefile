ESYNC			= $(shell hcLocation esync)
OPENHC                  = $(ESYNC)/openhc
DEL_BOOKMARKS_IN_DIR	= $(OPENHC)/tags
GENERATED		= $(DEL_BOOKMARKS_IN_DIR)/.generated
DEL_TO_RDF		= $(OPENHC)/delicious-bookmarks-to-rdf
RDF_DIR                 = ~
TRIPLE_BROWSER_DIR      = $(OPENHC)/rdf-triple-browser/java/swing
DEL_BOOKMARK_TTL_FILES = \
	$(GENERATED)/delicious-2017-07-14-public.ttl
DEL_BOOKMARK_RDF_FILES = \
	$(RDF_DIR)/delicious-2017-07-14-public.rdf

all : bmkToTtl ttlToRdf
clean : FORCE
	rm -rf $(GENERATED)
bmkToTtl : $(GENERATED) $(DEL_BOOKMARK_TTL_FILES)
ttlToRdf : $(GENERATED) $(DEL_BOOKMARK_RDF_FILES)
startTripleBrowser : FORCE
	cd $(TRIPLE_BROWSER_DIR); mvn exec:java -Dexec.mainClass="org.openhc.triplebrowser.swing.client.TripleBrowser"

$(GENERATED)/%.ttl : $(DEL_BOOKMARKS_IN_DIR)/%.html
	cd $(DEL_TO_RDF); stack exec delicious-bookmarks-to-rdf $< $@

$(RDF_DIR)/%.rdf : $(GENERATED)/%.ttl
	java -jar rdf2rdf-1.0.1-2.3.1.jar $< $@

$(GENERATED) :: FORCE
	mkdir -p $(GENERATED)

FORCE ::
