
third_party_core: path \
	                gflags \
                  glog \
                  gperftools \
								  snappy \
                  sparsehash \
									fastapprox

third_party_all: third_party_core \
									boost \
                  oprofile

# These might not build.
third_party_unused: gtest \
										libcuckoo \
										iftop \
										leveldb

.PHONY: third_party_core third_party_all third_party_unused

# ==================== boost ====================

BOOST_SRC = $(THIRD_PARTY_SRC)/boost_1_58_0.tar.bz2
BOOST_INCLUDE = $(THIRD_PARTY_INCLUDE)/boost

boost: $(BOOST_INCLUDE)

$(BOOST_INCLUDE): $(BOOST_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./bootstrap.sh \
		--prefix=$(THIRD_PARTY); \
	./b2 install

# ==================== fastapprox ===================

FASTAPPROX_SRC = $(THIRD_PARTY_SRC)/fastapprox-0.3.2.tar.gz
FASTAPPROX_INC = $(THIRD_PARTY_INCLUDE)/fastapprox

fastapprox: $(FASTAPPROX_INC)

$(FASTAPPROX_INC): $(FASTAPPROX_SRC)
	tar xzf $< -C $(THIRD_PARTY_SRC)
	mkdir $(THIRD_PARTY_INCLUDE)/fastapprox
	cp $(basename $(basename $<))/src/*.h $(THIRD_PARTY_INCLUDE)/fastapprox

# ===================== gflags ===================

GFLAGS_SRC = $(THIRD_PARTY_SRC)/gflags-2.0.tar.gz
GFLAGS_LIB = $(THIRD_PARTY_LIB)/libgflags.so

gflags: $(GFLAGS_LIB)

$(GFLAGS_LIB): $(GFLAGS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ===================== glog =====================

GLOG_SRC = $(THIRD_PARTY_SRC)/glog-0.3.3.tar.gz
GLOG_LIB = $(THIRD_PARTY_LIB)/libglog.so

glog: $(GLOG_LIB)

$(GLOG_LIB): $(GLOG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== gperftools =================

GPERFTOOLS_SRC = $(THIRD_PARTY_SRC)/gperftools-2.4.tar.gz
GPERFTOOLS_LIB = $(THIRD_PARTY_LIB)/libtcmalloc.so

gperftools: $(GPERFTOOLS_LIB)

$(GPERFTOOLS_LIB): $(GPERFTOOLS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# =================== oprofile ===================
# NOTE: need libpopt-dev binutils-dev

OPROFILE_SRC = $(THIRD_PARTY_SRC)/oprofile-1.0.0.tar.gz
OPROFILE_LIB = $(THIRD_PARTY_LIB)/oprofile

oprofile: $(OPROFILE_LIB)

$(OPROFILE_LIB): $(OPROFILE_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== sparsehash ==================

SPARSEHASH_SRC = $(THIRD_PARTY_SRC)/sparsehash-2.0.2.tar.gz
SPARSEHASH_INCLUDE = $(THIRD_PARTY_INCLUDE)/sparsehash

sparsehash: $(SPARSEHASH_INCLUDE)

$(SPARSEHASH_INCLUDE): $(SPARSEHASH_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== snappy ===================

SNAPPY_SRC = $(THIRD_PARTY_SRC)/snappy-1.1.2.tar.gz
SNAPPY_LIB = $(THIRD_PARTY_LIB)/libsnappy.so

snappy: $(SNAPPY_LIB)

$(SNAPPY_LIB): $(SNAPPY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== zeromq ====================

ZMQ_SRC = $(THIRD_PARTY_SRC)/zeromq-3.2.5.tar.gz
ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so

zeromq: $(ZMQ_LIB)

$(ZMQ_LIB): $(ZMQ_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install
	cp $(THIRD_PARTY_SRC)/zmq.hpp $(THIRD_PARTY_INCLUDE)


####################### Unused #####################

# ===================== gtest ====================

GTEST_SRC = $(THIRD_PARTY_SRC)/gtest-1.7.0.tar
GTEST_LIB = $(THIRD_PARTY_LIB)/libgtest_main.a

gtest: $(GTEST_LIB)

$(GTEST_LIB): $(GTEST_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $<)/make; \
	make; \
	./sample1_unittest; \
	cp -r ../include/* $(THIRD_PARTY_INCLUDE)/; \
	cp gtest_main.a $@

# ===================== libcuckoo =====================

CUCKOO_SRC = $(THIRD_PARTY_SRC)/libcuckoo.tar
CUCKOO_INCLUDE = $(THIRD_PARTY_INCLUDE)/libcuckoo

cuckoo: $(CUCKOO_INCLUDE)

$(CUCKOO_INCLUDE): $(CUCKOO_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	autoreconf -fis; \
	./configure --prefix=$(THIRD_PARTY); \
	make; make install

# ================== iftop ==================

IFTOP_SRC = $(THIRD_PARTY_SRC)/iftop-1.0pre4.tar.gz
IFTOP_BIN = $(THIRD_PARTY_BIN)/iftop

iftop: $(IFTOP_BIN)

$(IFTOP_BIN): $(IFTOP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install; \
	cp iftop $(IFTOP_BIN)

# ==================== leveldb ===================

LEVELDB_SRC = $(THIRD_PARTY_SRC)/leveldb-1.15.0.tar.gz
LEVELDB_LIB = $(THIRD_PARTY_LIB)/libleveldb.so

leveldb: $(LEVELDB_LIB)

$(LEVELDB_LIB): $(LEVELDB_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	LIBRARY_PATH=$(THIRD_PARTY_LIB):${LIBRARY_PATH} \
	make; \
	cp ./libleveldb.* $(THIRD_PARTY_LIB)/; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/
