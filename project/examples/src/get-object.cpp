/*
 * Copyright (C) 2005 National Association of REALTORS(R)
 *
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished
 * to do so, provided that the above copyright notice(s) and this
 * permission notice appear in all copies of the Software and that
 * both the above copyright notice(s) and this permission notice
 * appear in supporting documentation.
 */
 
#include "librets.h"
#include "Options.h"
#include <iostream>
#include <boost/lexical_cast.hpp>
#include <boost/algorithm/string.hpp>

using namespace librets;
using namespace librets::util;
using namespace std;
using boost::lexical_cast;
namespace po = boost::program_options;
namespace ba = boost::algorithm;

int main(int argc, char * argv[])
{
    try
    {
        string resource;
        string type;
        string resourceEntity;
        string objectId;
        string outputPrefix;
        bool returnUrl;
        vector<string> resourceSets;
        bool ignoreMalformedHeaders;
        
        Options options;
        options.descriptions.add_options()
            ("resource,r", po::value<string>(&resource)
             ->default_value("Property"), "Object resource")
            ("type", po::value<string>(&type)
             ->default_value("Photo"), "Object type")
            ("output-prefix", po::value<string>(&outputPrefix)
             ->default_value(""), "Output file prefix")
            ("resource-set", po::value< vector<string> >(&resourceSets),
             "Resource sets (e.g. 'resource-id' or 'resource-id:#,#'))")
            ("return-url", po::value<bool>(&returnUrl)
             ->default_value(false), "Return the URL to the object (true or false)")
            ("ignore-malformed-headers", po::value<bool>(&ignoreMalformedHeaders)
             ->default_value(false), "Ignore malformed headers (true or false)")
            ;
        if (!options.ParseCommandLine(argc, argv))
        {
            return 1;
        }
        
        if (resourceSets.size() == 0)
        {
            resourceSets.push_back("1");
        }

        RetsSessionPtr session = options.RetsLogin();
        if (!session)
        {
            cout << "Login failed\n";
            return -1;
        }
    
        GetObjectRequest getObjectRequest(resource, type);
    
        vector<string>::const_iterator i;
        for (i = resourceSets.begin(); i != resourceSets.end(); i++)
        {
            vector<string> resourceSet;
            ba::split(resourceSet, *i, ba::is_any_of(":"));
            if (resourceSet.size() == 1)
            {
                getObjectRequest.AddAllObjects(resourceSet[0]);
            }
            else if (resourceSet.size() == 2)
            {
                vector<string> ids;
                ba::split(ids, resourceSet[1], ba::is_any_of(","));
                vector<string>::const_iterator idString;
                for (idString = ids.begin(); idString != ids.end();
                     idString++)
                {
                    int id  = lexical_cast<int>(*idString);
                    getObjectRequest.AddObject(resourceSet[0], id);
                }
            }
        }
        getObjectRequest.SetLocation(returnUrl);
        getObjectRequest.SetIgnoreMalformedHeaders(ignoreMalformedHeaders);
    
        GetObjectResponseAPtr getObjectResponse =
            session->GetObject(&getObjectRequest);
    
        StringMap contentTypeSuffixes;
        contentTypeSuffixes["image/jpeg"] = "jpg";
        contentTypeSuffixes["text/xml"] = "xml";
        ObjectDescriptor * objectDescriptor;
        while ((objectDescriptor = getObjectResponse->NextObject()))
        {
            int retsReplyCode = objectDescriptor->GetRetsReplyCode();
            string retsReplyText = objectDescriptor->GetRetsReplyText();
            
            string objectKey = objectDescriptor->GetObjectKey();
            int objectId = objectDescriptor->GetObjectId();
            string contentType = objectDescriptor->GetContentType();
            string description = objectDescriptor->GetDescription();
            string location = objectDescriptor->GetLocationUrl();
            
            if (objectDescriptor->GetWildIndicator())
                cout << objectKey << " object #: *";
            else
                cout << objectKey << " object #" << objectId;
            if (!description.empty())
                cout << ", description: " << description;
            if (!location.empty())
                cout << ", location: " << location;
            if (retsReplyCode)
                cout << ", **** " << retsReplyCode << ": " << retsReplyText;
                
            cout << endl;
            
            string suffix = contentTypeSuffixes[contentType];
            string outputFileName = outputPrefix + objectKey + "-" +
                lexical_cast<string>(objectId) + "." + suffix;
            /*
             * Only save the object if there was no error and we're not
             * using the location option.
             */
            if (retsReplyCode == 0 && location.empty())
            {
                ofstream outputStream(outputFileName.c_str());
                istreamPtr inputStream = objectDescriptor->GetDataStream();
                readUntilEof(inputStream, outputStream);
            }
        }
    
        session->Logout();
    }
    catch (RetsException & e)
    {
        e.PrintFullReport(cerr);
    }
    catch (std::exception & e)
    {
        cerr << e.what() << endl;
    }
}
