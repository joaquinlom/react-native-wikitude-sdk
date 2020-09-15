//
//  InterfaceOrientation.h
//  CommonLibrary
//
//  Created by Daniel Guttenberg on 08/04/16.
//  Copyright © 2016 Wikitude. All rights reserved.
//

#ifndef InterfaceOrientation_h
#define InterfaceOrientation_h

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

namespace wikitude { namespace sdk {
    
    namespace impl {
        
<<<<<<< HEAD
        enum InterfaceOrientation : int {
=======
        enum WT_EXPORT_API InterfaceOrientation : int {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            InterfaceOrientationLandscapeLeft = 90,
            InterfaceOrientationLandscapeRight = -90,
            InterfaceOrientationPortrait = 0,
            InterfaceOrientationPortraitUpsideDown = 180,
            InterfaceOrientationUnknown
        };
    }
    using impl::InterfaceOrientation;
}}

#endif /* __cplusplus */

#endif /* InterfaceOrientation_h */
