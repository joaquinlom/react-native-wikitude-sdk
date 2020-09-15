//
//  RenderingPluginModule.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 17.06.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef RenderingPluginModule_hpp
#define RenderingPluginModule_hpp

#ifdef __cplusplus

#include "PluginModule.hpp"
<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318


namespace wikitude { namespace sdk {

    namespace impl {


<<<<<<< HEAD
        class RenderingPluginModule : public PluginModule {
=======
        class WT_EXPORT_API RenderingPluginModule : public PluginModule {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            virtual ~RenderingPluginModule() = default;
        };
    }
    using impl::RenderingPluginModule;
}}

#endif /* __cplusplus */

#endif /* RenderingPluginModule_hpp */
