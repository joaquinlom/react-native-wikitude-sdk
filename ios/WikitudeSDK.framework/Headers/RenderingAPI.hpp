//
//  RenderingAPI.hpp
//
//  Created by Alexandru Florea on 28/02/17.
//  Copyright © 2017 Wikitude. All rights reserved.
//

#ifndef RenderingAPI_hpp
#define RenderingAPI_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"

>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318

namespace wikitude { namespace sdk {
    
    namespace impl {
        
<<<<<<< HEAD
        enum class RenderingAPI {
=======
        enum class WT_EXPORT_API RenderingAPI {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            OpenGL_ES_2,
            OpenGL_ES_3,
            Metal,
            DirectX,
            None,
            RenderingAPIs
        };    
    }
    using impl::RenderingAPI;
}}

#endif /* __cplusplus */

#endif /* RenderingAPI_hpp */
