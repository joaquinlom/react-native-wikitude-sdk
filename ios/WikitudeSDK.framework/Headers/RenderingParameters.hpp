//
//  RenderingParameters.hpp
//  WikitudeiOSComponent
//
//  Created by Andreas Schacherbauer on 18.01.18.
//  Copyright © 2018 Wikitude. All rights reserved.
//

#ifndef RenderingParameters_hpp
#define RenderingParameters_hpp

#ifdef __cplusplus

<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"


>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
namespace wikitude {
    namespace sdk {
        namespace impl {
            enum class RenderingAPI;
        }
        using impl::RenderingAPI;
    }
    namespace universal_sdk {
        namespace impl {
            class RenderingParametersInternal;
        }
        using impl::RenderingParametersInternal;
    }
}

namespace wikitude { namespace sdk {

    namespace impl {


<<<<<<< HEAD
        class RenderingParameters {
=======
        class WT_EXPORT_API RenderingParameters {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            RenderingParameters(universal_sdk::RenderingParametersInternal& internalRenderingParameters_);

            sdk::RenderingAPI getActiveRenderingAPI() const;

            unsigned int getPreferredFramesPerSecond() const;

        protected:
            universal_sdk::RenderingParametersInternal&     _internalRenderingParameters;
        };
    }
    using impl::RenderingParameters;
}}

#endif /* __cplusplus */

#endif /* RenderingParameters_hpp */
