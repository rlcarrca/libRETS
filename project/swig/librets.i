%module(directors="1") librets

#ifdef SWIGCSHARP
%{
#include "librets_sharp.h"
%}
#endif

#ifdef SWIGJAVA
%include "java/boost_shared_ptr.i"
#endif

#ifdef SWIGRUBY
%{
#include "librets_ruby.h"
%}
#endif

#ifdef SWIGPHP
%include "boost_shared_ptr.i"
%copyctor;
#endif

#ifdef SWIGPERL
%{
#undef Copy
%}
#endif

%{
#include "librets.h"
#include <iostream>
#include <sstream>

using namespace librets;
using namespace librets::util;
using std::vector;
using std::string;
%}

#ifndef SWIGXML
%include "std_string.i"
#ifndef SWIGPHP
%include "std_vector.i"
#else
%include <std_common.i>
%{
#include <vector>
#include <algorithm>
#include <stdexcept>
%}
namespace std {

    template<class T> class vector {
        // add generic typemaps here
      public:
        vector(unsigned int size = 0);
        unsigned int size() const;
        %rename(is_empty) empty;
        bool empty() const;
        void clear();
        %rename(push) push_back;
        void push_back(const T& x);
        %extend {
            T pop() throw (std::out_of_range) {
                if (self->size() == 0)
                    throw std::out_of_range("pop from empty vector");
                T x = self->back();
                self->pop_back();
                return x;
            }
            T get(int i) throw (std::out_of_range) {
                int size = int(self->size());
                if (i>=0 && i<size)
                    return (*self)[i];
                else
                    throw std::out_of_range("vector index out of range");
            }
            void set(int i, const T& x) throw (std::out_of_range) {
                int size = int(self->size());
                if (i>=0 && i<size)
                    (*self)[i] = x;
                else
                    throw std::out_of_range("vector index out of range");
            }
        }
    };
}
#endif
#endif
%include "exception.i"
%include "auto_ptr_release.i"

typedef std::vector<std::string> StringVector;
%template(StringVector) std::vector<std::string>;
%template(ByteVector) std::vector<unsigned char>;

#ifdef SWIGCSHARP
%include "shared_ptr_release.i"
%typemap(ctype)  unsigned char[] "unsigned char*"
%typemap(cstype) unsigned char[] "byte[]"
%typemap(csin)   unsigned char[] "$csinput"
%typemap(imtype) unsigned char[] "byte[]"
%typemap(in)     unsigned char[] {$1 = $input;}
#endif

%typemap(out) std::vector<unsigned char>
{
    
}

%exception {
    try {
        $action
    } catch(std::exception & e) {
        std::string message = std::string(e.what()) + "\n";
        SWIG_exception(SWIG_ValueError, message.c_str());
    } catch(...) {
        SWIG_exception(SWIG_RuntimeError,"Unknown exception\n");
    }
}

%nodefault RetsException;
class RetsException
{
  public:
    virtual std::string GetMessage();

    virtual std::string GetExtendedMessage();
};

class LoginResponse 
{
  public:
    std::string GetMemberName() const;

    std::string GetUserInfo() const;

    std::string GetBroker() const;

    std::string GetMetadataVersion() const;

    std::string GetMetadataTimestamp() const;

    std::string GetMinMetadataTimestamp() const;

    std::string GetOfficeList() const;

    std::string GetBalance() const;

    std::string GetTimeout() const;

    std::string GetPasswordExpire() const;

    std::string GetActionUrl() const;

    std::string GetChangePasswordUrl() const;

    std::string GetGetObjectUrl() const;

    std::string GetLoginUrl() const;

    std::string GetLoginCompleteUrl() const;

    std::string GetLogoutUrl() const;

    std::string GetSearchUrl() const;

    std::string GetGetMetadataUrl() const;

    std::string GetServerInformationUrl() const;

    std::string GetUpdateUrl() const;
};

class CapabilityUrls
{
  public:
    CapabilityUrls(std::string baseUrl);

    virtual ~CapabilityUrls();

    void SetActionUrl(std::string actionUrl);

    std::string GetActionUrl() const;

    void SetChangePasswordUrl(std::string changePasswordUrl);

    std::string GetChangePasswordUrl() const;

    void SetGetObjectUrl(std::string getObjectUrl);

    std::string GetGetObjectUrl() const;

    void SetLoginUrl(std::string loginUrl);

    std::string GetLoginUrl() const;

    void SetLoginCompleteUrl(std::string loginCompleteUrl);

    std::string GetLoginCompleteUrl() const;

    void SetLogoutUrl(std::string logoutUrl);

    std::string GetLogoutUrl() const;

    void SetSearchUrl(std::string searchUrl);

    std::string GetSearchUrl() const;

    void SetGetMetadataUrl(std::string getMetadataUrl);

    std::string GetGetMetadataUrl() const;

    void SetServerInformationUrl(std::string serverInformationUrl);

    std::string GetServerInformationUrl() const;

    void SetUpdateUrl(std::string updateUrl);

    std::string GetUpdateUrl() const;
};

class SearchRequest
{
  public:
    SearchRequest(std::string searchType, std::string searchClass,
                  std::string query);
    
    void SetStandardNames(bool standardNames);

    void SetSelect(std::string select);
    
    static const int LIMIT_DEFAULT = -1;
    static const int LIMIT_NONE = 0;
    void SetLimit(int limit);
    
    static const int OFFSET_NONE = 0;
    void SetOffset(int offset);
    
    enum CountType
    {
        NO_RECORD_COUNT,
        RECORD_COUNT_AND_RESULTS,
        RECORD_COUNT_ONLY
    };
    void SetCountType(CountType countType);
    
    enum QueryType
    {
        DMQL,
        DMQL2
    };
    void SetQueryType(QueryType queryType);

    enum FormatType
    {
        COMPACT,
        COMPACT_DECODED
    };
    void SetFormatType(FormatType formatType);

    // This is really from RetsHttpRequest, but SearchRequest is a
    // child of that language, so this should work.  Until we need to,
    // we won't expose RetsHttpRequest
    std::string GetQueryString() const;
};
typedef std::auto_ptr<SearchRequest> SearchRequestAPtr;
#ifndef SWIGPHP
%template(SearchRequestAPtr) std::auto_ptr<SearchRequest>;
#endif

class SearchResultSet
{
  public:
    bool HasNext();
    
    int GetCount();
    
    const std::vector<std::string> GetColumns();
    
    std::string GetString(int columnIndex);
    
    std::string GetString(std::string columnName);

    void SetEncoding(EncodingType encoding);

    EncodingType GetEncoding();

    bool HasMaxRows();

    int GetReplyCode();

    std::string GetReplyText();
};
typedef std::auto_ptr<SearchResultSet> SearchResultSetAPtr;
#ifndef SWIGPHP
%template(SearchResultSetAPtr) std::auto_ptr<SearchResultSet>;
#endif

class LogoutResponse
{
  public:
    std::string GetBillingInfo();
    std::string GetLogoutMessage();
    int GetConnectTime();
};
typedef std::auto_ptr<LogoutResponse> LogoutResponseAPtr;
#ifndef SWIGPHP
%template(LogoutResponseAPtr) std::auto_ptr<LogoutResponse>;
#endif

SWIG_AUTO_PTR_RELEASE(SearchRequest);
SWIG_AUTO_PTR_RELEASE(SearchResultSet);
SWIG_AUTO_PTR_RELEASE(LogoutResponse);

/****************************************************************************
 * GetObject
 ***************************************************************************/

typedef std::auto_ptr<InputStreamBridge> InputStreamBridgeAPtr;
SWIG_AUTO_PTR_RELEASE(InputStreamBridge);


class GetObjectRequest
{
  public:
%immutable;
    static const char * PHOTO_TYPE;
    static const char * PLAT_TYPE;
    static const char * VIDEO_TYPE;
    static const char * AUDIO_TYPE;
    static const char * THUMBNAIL_TYPE;
    static const char * MAP_TYPE;
    static const char * VRIMAGE_TYPE;
%mutable;

    GetObjectRequest(std::string resource, std::string type);
    
    bool GetLocation() const;
    
    void SetLocation(bool location);
    
    void AddObject(std::string resourceEntity, int objectId);
    
    void AddAllObjects(std::string resourceEntity);

    void SetIgnoreMalformedHeaders(bool ignore);
};


/*
 * Handling of the binary object data is a bit tricky.  Each language has
 * its own issues.
 *
 * Ruby
 * ====
 *
 * In Ruby, characters are 8-bits and strings may contain null characters.
 * This is very similar to C++ strings, so the binary data can be retrieved
 * with std::string.
 *
 * C#
 * ==
 *
 * In C#, characters are 16-bits, so strings cannot be used to represent
 * binary data.  C# does have a byte type, and a byte array (byte[]) can
 * be used to represent binary data.  The object data stream is also
 * represented as a native C# stream, using an intermediate bridge class
 * (InputStreamBridge).
 */
 
 
#ifdef SWIGCSHARP

%nodefault InputStreamBridge;
class InputStreamBridge
{
  public:
    int readByte() const;
    int read(unsigned char buffer[], int offset, int length) const; 
};

class BinaryData
{
  public:
        int Size() const;
        std::string AsString() const;
        const char * AsChar() const;
        void Copy(unsigned char buffer[], int length) const; 
};
typedef std::auto_ptr<BinaryData> BinaryDataAPtr;
SWIG_AUTO_PTR_RELEASE(BinaryData);

%typemap(cscode) ObjectDescriptor %{
    public byte[] GetDataAsBytes()
    {
        BinaryData binaryData = GetData();
        int length = binaryData.Size();
        byte[] bytes = new byte[length];
        binaryData.Copy(bytes, bytes.Length);
        return bytes;
    }
    
    public System.IO.Stream GetDataStream()
    {
        return new CppInputStream(GetDataStreamBridge());
    }
%}

#endif

class ObjectDescriptor
{
  public:
    std::string GetObjectKey() const;
    
    int GetObjectId() const;
    
    std::string GetDescription() const;
    
    std::string GetLocationUrl() const;
    
    std::string GetContentType() const;
    
#if defined(SWIGRUBY) || defined(SWIGPYTHON)
    %extend {
        std::string GetDataAsString()
        {
            istreamPtr inputStream = self->GetDataStream();
            return readIntoString(inputStream);
        }
    }
#endif
    
#ifdef SWIGCSHARP
    BinaryDataAPtr GetData();

    %extend {
        InputStreamBridgeAPtr GetDataStreamBridge()
        {
            InputStreamBridgeAPtr streamBridge(
                new InputStreamBridge(self->GetDataStream()));
            return streamBridge;
        }
    }
#endif
};



%typemap(csimports) GetObjectResponse %{
using System;
using System.Runtime.InteropServices;
using System.Collections;
%};
%typemap(csbase) GetObjectResponse "IEnumerable";

%typemap(cscode) GetObjectResponse %{
    public IEnumerator GetEnumerator()
    {
        return new ObjectDescriptorEnumerator(this);
    }
%}


class GetObjectResponse
{
  public:
    ObjectDescriptor * NextObject();
};
typedef std::auto_ptr<GetObjectResponse> GetObjectResponseAPtr;

SWIG_AUTO_PTR_RELEASE(GetObjectResponse);

/****************************************************************************
 * Metadata
 ***************************************************************************/
 
#ifdef SWIGPHP
#define CLASS KLASS
%{
#define KLASS CLASS
%}
#endif

class MetadataElement
{
  public:
    enum MetadataType
    {
        /** System metadata. */
        SYSTEM,
        /** Resource metadata. */
        RESOURCE,
        /** Class metadata. */
        CLASS,
        /** Table metadata. */
        TABLE,
        /** Update metadata. */
        UPDATE,
        /** Update type metadata. */
        UPDATE_TYPE,
        /** Object metadata. */
        OBJECT,
        /** Search help metadata. */
        SEARCH_HELP,
        /** Edit mask metadata. */
        EDIT_MASK,
        /** Lookup metadata. */
        LOOKUP,
        /** Lookup type metadata. */
        LOOKUP_TYPE,
        /** Update help metadata. */
        UPDATE_HELP,
        /** Validation lookup metadata. */
        VALIDATION_LOOKUP,
        /** Validation lookup type metadata. */
        VALIDATION_LOOKUP_TYPE,
        /** Validation external metadata. */
        VALIDATION_EXTERNAL,
        /** Validation external type metadata. */
        VALIDATION_EXTERNAL_TYPE,
        /** Validation expression metadata. */
        VALIDATION_EXPRESSION,
        /** Foreign key metadata. */
        FOREIGN_KEY
    };
    typedef MetadataType Type;

    %rename(GetMetadataType) GetType() const;
    virtual MetadataType GetType() const = 0;
    
    StringVector GetAttributeNames() const;

    std::string GetStringAttribute(std::string attributeName,
                                   std::string defaultValue = "") const;
   
    int GetIntAttribute(std::string attributeName, int defaultValue = 0) const;
    
    bool GetBoolAttribute(std::string attributeName, bool defaultValue = false)
        const;

    virtual std::string GetId() const;

    std::string GetLevel() const;

    std::string GetPath() const;
};

class MetadataSystem : public MetadataElement
{
  public:
    std::string GetSystemID() const;  
    std::string GetSystemDescription() const;
    std::string GetComments() const;
    MetadataType GetType() const;
};

class MetadataResource : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetResourceID() const;
    std::string GetStandardName() const;
    std::string GetKeyField() const;
    MetadataType GetType() const;
};

typedef std::vector<MetadataResource *> MetadataResourceList;
%template(MetadataResourceList) std::vector<MetadataResource *>;

class MetadataClass : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetClassName() const;
    std::string GetStandardName() const;
    std::string GetDescription() const;
    MetadataType GetType() const;
};

typedef std::vector<MetadataClass *> MetadataClassList;
%template(MetadataClassList) std::vector<MetadataClass *>;

class MetadataTable : public MetadataElement
{
  public:
    enum DataType
    {
        BOOLEAN,
        CHARACTER,
        DATE,
        DATE_TIME,
        TIME,
        TINY,
        SMALL,
        INT,
        LONG,
        DECIMAL
    };

    enum Interpretation
    {
        NUMBER,
        CURRENCY,
        LOOKUP,
        LOOKUP_MULTI,
        LOOKUP_BITSTRING,
        LOOKUP_BITMASK,
        NO_INTERPRETATION
    };
    
    enum Alignment
    {
        LEFT,
        RIGHT,
        CENTER,
        JUSTIFY,
        NO_ALIGNMENT
    };
    
    enum Units
    {
        FEET,
        METERS,
        SQUARE_FEET,
        SQUARE_METERS,
        ACRES,
        HECTARES,
        NO_UNITS
    };

    std::string GetSystemName() const;
    std::string GetStandardName() const;
    std::string GetLongName() const;
    std::string GetDBName() const;
    std::string GetShortName() const;
    int GetMaximumLength() const;
    DataType GetDataType() const;
    int GetPrecision() const;
    bool IsSearchable() const;
    Interpretation GetInterpretation() const;
    Alignment GetAlignment() const;
    bool UseSeparator() const;
    std::string GetEditMaskId() const;
    std::string GetLookupName() const;
    int GetMaxSelect() const;
    Units GetUnits() const;
    int GetIndex() const;
    int GetMinimum() const;
    std::string GetMinimumAsString() const;
    int GetMaximum() const;
    std::string GetMaximumAsString() const;
    int GetDefault() const;
    int GetRequired() const;
    std::string GetSearchHelpId() const;
    MetadataType GetType() const;
    bool IsUnique() const;
};

typedef std::vector<MetadataTable *> MetadataTableList;
%template(MetadataTableList) std::vector<MetadataTable *>;

class MetadataLookup : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetLookupName() const;
    std::string GetVisibleName() const;
    std::string GetVersion() const;
    std::string GetDate() const;
    MetadataType GetType() const;
};

typedef std::vector<MetadataLookup *> MetadataLookupList;
%template(MetadataLookupList) std::vector<MetadataLookup *>;

class MetadataLookupType : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetValue() const;
    std::string GetLongValue() const;
    std::string GetShortValue() const;
    MetadataType GetType() const;
};

typedef std::vector<MetadataLookupType *> MetadataLookupTypeList;
%template(MetadataLookupTypeList) std::vector<MetadataLookupType *>;

class MetadataObject : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetObjectType() const;
    std::string GetMIMEType() const;
    std::string GetVisibleName() const;
    std::string GetDescription() const;
    MetadataType GetType() const;
};

typedef std::vector<MetadataObject *> MetadataObjectList;
%template(MetadataObjectList) std::vector<MetadataObject *>;

class MetadataSearchHelp : public MetadataElement
{
  public:
    std::string GetId() const;
    std::string GetSearchHelpID() const;
    std::string GetValue() const;
    MetadataType GetType() const;
};

%nodefault;

class RetsMetadata
{
  public:
    MetadataSystem * GetSystem() const;

    MetadataResourceList GetAllResources() const;
    MetadataResource * GetResource(std::string resourceName) const;
    
    MetadataClassList GetAllClasses(std::string resourceName) const;
    MetadataClass * GetClass(std::string resourceName,
        std::string className) const;
        
    MetadataTableList GetAllTables(MetadataClass * metadataClass) const;
    
    MetadataTableList GetAllTables(std::string resourceName,
                                   std::string className) const;

    MetadataTable * GetTable(std::string resourceName, std::string className,
                             std::string tableName) const;

    MetadataLookupList GetAllLookups(std::string resourceName) const;
    
    MetadataLookup * GetLookup(std::string resourceName,
        std::string lookupName) const;
    
    MetadataLookupTypeList GetAllLookupTypes(std::string resrouceName,
                                             std::string lookupName) const;
    
    MetadataLookupTypeList GetAllLookupTypes(MetadataLookup * metadataLookup)
        const;
    
    MetadataLookupType * GetLookupType(std::string resourceName,
                                       std::string lookupName,
                                       std::string lookupValue) const;

    MetadataObjectList GetAllObjects(std::string resourceName) const;

    MetadataObjectList GetAllObjects(MetadataResource * metadataResource)
        const;

    MetadataSearchHelp * GetSearchHelp(std::string resourceName,
                                       std::string searchHelpID) const;
};

%default;
 
/****************************************************************************
 * RetsSession
 ***************************************************************************/

enum RetsVersion
{
    RETS_1_0,
    RETS_1_5
};

enum EncodingType
{
    RETS_XML_DEFAULT_ENCODING,
    RETS_XML_ISO_ENCODING
};

enum UserAgentAuthType
{
    USER_AGENT_AUTH_RETS_1_7,
    USER_AGENT_AUTH_INTEREALTY,
};


#ifdef SWIGCSHARP
// Right now, we have a hand rolled delegate for logging in CSharp.
// Eventually we'll move this over to using directors.
%typemap(cscode) RetsHttpLogger %{
    public delegate void Delegate(Type type, byte[] data);
    public delegate void NativeDelegate(Type type, IntPtr data, int length);
%}
#endif

// For right now, a director for RetsHttpLogger has only been defined
// for ruby.  This also adds some ruby GC magic to make sure the director
// class isn't cleaned up before RetsSession.
#ifdef SWIGRUBY
%trackobjects;
%markfunc RetsSession "mark_RetsSession";

%header %{
static void mark_RetsSession(void* ptr)
{
    RetsSession* session = (RetsSession*) ptr;

    RetsHttpLogger* logger = session->GetHttpLogger();

    VALUE object = SWIG_RubyInstanceFor(logger);

    if (object != Qnil) {
        rb_gc_mark(object);
    }
}
%}

%feature("director") RetsHttpLogger;
#endif
class RetsHttpLogger
{
  public:
    enum Type
    {
        RECEIVED,
        SENT,
        INFORMATIONAL
    };

    virtual ~RetsHttpLogger();

    virtual void logHttpData(Type type, std::string data) = 0;
};

#ifdef SWIGCSHARP
%typemap(ctype)  RetsHttpLoggerCallback "RetsHttpLoggerCallback"
%typemap(cstype) RetsHttpLoggerCallback "RetsHttpLogger.NativeDelegate"
%typemap(csin)   RetsHttpLoggerCallback "$csinput"
%typemap(imtype) RetsHttpLoggerCallback "RetsHttpLogger.NativeDelegate"
%typemap(in)     RetsHttpLoggerCallback {$1 = $input;}

typedef void (*RetsHttpLoggerCallback)(RetsHttpLogger::Type type,
    void * data, int length);

class RetsHttpLoggerBridge : public RetsHttpLogger
{
  public:
    RetsHttpLoggerBridge(RetsHttpLoggerCallback loggerCallback);
    void logHttpData(Type type, std::string data);
};

%csmethodmodifiers RetsSession::SetHttpLogger "private";

%typemap(cscode) RetsSession %{
    private RetsHttpLogger.Delegate mLoggerDelegate = null;
    private RetsHttpLogger.NativeDelegate mNativeDelegate = null;
    private RetsHttpLogger mLogger = null;

    public RetsHttpLogger.Delegate LoggerDelegate
    {
        get { return mLoggerDelegate; }
        set
        {
            mLoggerDelegate = value;

            if (mLoggerDelegate != null)
            {
                // Need to save references to both the delegate and
                // the logger otherwise they will be garbage collected
                // while still in use.
                mNativeDelegate = new RetsHttpLogger.NativeDelegate(
                    this.LoggerDelegateBridge);
                mLogger = new RetsHttpLoggerBridge(mNativeDelegate);
                SetHttpLogger(mLogger);
            }
            else
            {
                // Disconnect callback prior to making them available
                // for GC
                SetHttpLogger(null);
                mLogger = null;
                mNativeDelegate = null;
            }
        }
    }
    
    private void LoggerDelegateBridge(RetsHttpLogger.Type type, IntPtr data,
        int length)
    {
        byte[] byteData = new byte[length];
        System.Runtime.InteropServices.Marshal.Copy(data, byteData, 0, length);
        mLoggerDelegate(type, byteData);
    }
%}

// The following few classes were added to see if we can get C# to
// call out to the translator.  This is commented out as its not ready
// for release as of yet.  When ready, also uncomment out the director
// line on top.
// 
%feature("director") SqlMetadata;
class SqlMetadata
{
  public:
    virtual ~SqlMetadata() { };

    virtual bool IsLookupColumn(std::string tableName, std::string columnName)
        = 0;
};

%typemap(cscode) SqlMetadata %{
      public SqlMetadataPtr metadataptr_reference;
      public SqlToDmqlCompilerPtr compiler_reference;

    public addCompilerReference (SlToDmqlCompilerPtr compiler_ptr)
    {
      compiler_reference = compiler_ptr;
    }
%}

class DmqlCriterion 
{
  public:
    virtual ~DmqlCriterion();

    virtual std::ostream & ToDmql(std::ostream & outputStream) const = 0;

    std::string ToDmqlString();
};

class DmqlQuery 
{
  public:
    DmqlQuery();
    virtual ~DmqlQuery();

    std::string GetResource() const;

    void SetResource(std::string resource);

    std::string GetClass() const;

    void SetClass(std::string aClass);

    /**
     * Returns a pointer to a StringVector.  DmqlQuery is responsible for
     * freeing the object.
     */
    StringVector * GetFieldsPtr() const;

    StringVectorPtr GetFields() const;

    void AddField(std::string column);

    /**
     * Returns a pointer to a DmqlCriterion.  DmqlQuery is responsible for
     * freeing the object.
     */
    DmqlCriterion * GetCriterionPtr() const;

    DmqlCriterionPtr GetCriterion() const;

    void SetCriterion(DmqlCriterionPtr criterion);

    int GetLimit() const;

    void SetLimit(int limit);

    int GetOffset() const;

    void SetOffset(int offset);

    SearchRequest::CountType GetCountType() const;

    void SetCountType(SearchRequest::CountType countType);

    virtual std::ostream & Print(std::ostream & outputStream) const;
};

typedef boost::shared_ptr<DmqlCriterion> DmqlCriterionPtr;
%template(DmqlCriterionPtr) boost::shared_ptr<DmqlCriterion>;

typedef boost::shared_ptr<DmqlQuery> DmqlQueryPtr;
%template(DmqlQueryPtr) boost::shared_ptr<DmqlQuery>;

typedef boost::shared_ptr<GetObjectQuery> GetObjectQueryPtr;
%template(GetObjectQueryPtr) boost::shared_ptr<GetObjectQuery>;

typedef boost::shared_ptr<SqlMetadata> SqlMetadataPtr;
%template(SqlMetadataPtr) boost::shared_ptr<SqlMetadata>;

/*
 * I can not figure out how to get SWIG to add this to the shared_ptr wrapper. The shared_ptr 
 * needs to reference SqlMetatadata, otherwise it is getting garbage collected before the
 * shared_ptr is released.
 */
//%typemap(cscode) SqlMetadataPtr  %{
//    public SqlMetadata metadata_reference = null;
//
//    public AddReference(SqlMetadata metadata)
//    {
//      metadata_reference = metadata;
//    }
//%}


typedef boost::shared_ptr<SqlToDmqlCompiler> SqlToDmqlCompilerPtr;
%template(SqlToDmqlCompilerPtr) boost::shared_ptr<SqlToDmqlCompiler>;

%typemap(cscode) SqlToDmqlCompiler %{
      private SqlMetadata metadata_reference = null;
      private SqlMetadataPtr metadataptr_reference = null;

    /*
     * Add a layer of indirection to attempt to reference the objects so they do not get
     * garbage collected. This too appears to fail. When in doubt, use brute force.
     */
    public SqlToDmqlCompiler(SqlMetadataPtr metadata_ptr, SqlMetadata metadata) : this(metadata_ptr)
    {
      metadataptr_reference = metadata_ptr;
      //metadataptr_reference.AddReference(metadata);
      /*
       * Since simply adding the reference doesn't appear to be stopping the garbage collector,
       * use brute force.
       */
      GC.SuppressFinalize(metadata_ptr);
    }

    /*
     * Wrap the metadata into a metadata pointer.
     */
    public SqlToDmqlCompiler(SqlMetadata metadata) : this(new SqlMetadataPtr(metadata), metadata) 
    {
      metadata_reference = metadata;
      /*
       * Since simply adding the reference doesn't appear to be stopping the garbage collector,
       * use brute force.
       */
      GC.SuppressFinalize(metadata);
    }
%}
%typemap(csfinalize) SqlToDmqlCompiler %{
    ~SqlToDmqlCompiler() 
    {
      /*
       * Clean up for ourselves.
       */
      Dispose();
      /*
       * We know we created the metadataptr, so go ahead and dispose it as well.
       */
      if (metadataptr_reference != null)
        metadataptr_reference.Dispose();
      metadataptr_reference = null;
      /*
       * Something appears to be destructing the metadata elsewhere, so we do not want
       * it garbage collected until that can be figured out. I suspect there may be
       * a memory leak around the director stuff.
       */
      //if (metadata_reference != null)
      //  GC.ReRegisterForFinalize(metadata_reference);
      metadata_reference = null;
    }
%}

class SqlToDmqlCompiler
{
  public:
    SqlToDmqlCompiler(SqlMetadataPtr metadata);
    
    enum QueryType {DMQL_QUERY, GET_OBJECT_QUERY};
    
    QueryType sqlToDmql(std::string sql);

    DmqlQueryPtr GetDmqlQuery() const;
    
    GetObjectQueryPtr GetGetObjectQuery() const;

};

#endif


class RetsSession
{
  public:
    RetsSession(std::string loginUrl);

    std::string GetLoginUrl() const;

    bool Login(std::string userName, std::string password);

    LoginResponse * GetLoginResponse() const;
    
    CapabilityUrls * GetCapabilityUrls() const;

    std::string GetAction();

    SearchRequestAPtr CreateSearchRequest(std::string searchType, 
                                          std::string searchClass,
                                          std::string query);

    SearchResultSetAPtr Search(SearchRequest * request);
    
    LogoutResponseAPtr Logout();
    
    RetsMetadata * GetMetadata();
    
    bool IsIncrementalMetadata() const;
    
    void SetIncrementalMetadata(bool incrementalMetadata);
    
    GetObjectResponseAPtr GetObject(GetObjectRequest * request);

    void SetUserAgent(std::string userAgent);

    void UseHttpGet(bool useHttpGet);
    
    void SetRetsVersion(RetsVersion retsVersion);
    
    RetsVersion GetRetsVersion() const;
    
    RetsVersion GetDetectedRetsVersion() const;

    void SetHttpLogger(RetsHttpLogger * logger);

    void SetUserAgentAuthType(UserAgentAuthType type);

    UserAgentAuthType GetUserAgentAuthType() const;
    
    void SetUserAgentPassword(std::string userAgentPassword);

    void SetDefaultEncoding(EncodingType encoding);

    void Cleanup();

    void SetLogEverything(bool logging);
};



/* Local Variables: */
/* mode: c++ */
/* End: */
