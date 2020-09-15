//
//  SensorEvent.hpp
//  WikitudeUniversalSDK
//
//  Created by Andreas Schacherbauer on 07/11/17.
//  Copyright (c) 2017 com.wikitude. All rights reserved.
//

#ifndef SensorEvent_hpp
#define SensorEvent_hpp

#ifdef __cplusplus

#include <memory>
<<<<<<< HEAD
=======
#include "CompilerAttributes.hpp"
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318


namespace wikitude { namespace sdk {
    
    namespace impl {


<<<<<<< HEAD
        struct DeviceMotionData {
=======
        struct WT_EXPORT_API DeviceMotionData {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            DeviceMotionData(std::shared_ptr<float> motion_)
            :
            _motion(std::move(motion_))
            { /* Intentionally Left Blank */ }

            std::shared_ptr<float> _motion;
        };

<<<<<<< HEAD
        typedef struct AccelerationData {
=======
        typedef struct WT_EXPORT_API AccelerationData {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            AccelerationData(double x_, double y_, double z_)
            :
            _x(x_),
            _y(y_),
            _z(z_)
            { /* Intentionally Left Blank */ }

            double  _x;
            double  _y;
            double  _z;
        } AccelerationData;

<<<<<<< HEAD
        typedef struct HeadingData {
=======
        typedef struct WT_EXPORT_API HeadingData {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
            HeadingData(double x_, double y_, double z_, double trueHeading_, double magneticHeading_)
            :
            _x(x_),
            _y(y_),
            _z(z_),
            _trueHeading(trueHeading_),
            _magneticHeading(magneticHeading_)
            { /* Intentionally Left Blank */ }

            double headingDeviation() const {
                return _trueHeading - _magneticHeading;
            }

            double  _x;
            double  _y;
            double  _z;

            double _trueHeading;
            double _magneticHeading;
        } HeadingData;


<<<<<<< HEAD
        class SensorEvent {
=======
        class WT_EXPORT_API SensorEvent {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            enum SensorEventType {
                DeviceRotation,
                DeviceOrientation,
                DeviceAcceleration,
                DeviceHeading
            };

        public:
            SensorEvent(SensorEventType eventType_);
            virtual ~SensorEvent();

            const SensorEventType& getEventType() const;
            
        private:
            SensorEventType                 _eventType;
        };


<<<<<<< HEAD
        class DeviceRotationEvent : public SensorEvent {
=======
        class WT_EXPORT_API DeviceRotationEvent : public SensorEvent {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            DeviceRotationEvent(DeviceMotionData rotationData_);

            const DeviceMotionData& getDeviceMotionData() const;

        private:
            DeviceMotionData            _rotationData;
        };

<<<<<<< HEAD
        class DeviceOrientationEvent : public SensorEvent {
=======
        class WT_EXPORT_API DeviceOrientationEvent : public SensorEvent {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            DeviceOrientationEvent(DeviceMotionData orientationData_);

            const DeviceMotionData& getDeviceMotionData() const;
        private:
            DeviceMotionData            _orientationData;
        };

<<<<<<< HEAD
        class AccelerationEvent : public SensorEvent {
=======
        class WT_EXPORT_API AccelerationEvent : public SensorEvent {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            AccelerationEvent(AccelerationData acceleration_);

            const AccelerationData& getAccelerationData() const;

        private:
            AccelerationData     _acceleration;
        };

<<<<<<< HEAD
        class HeadingEvent : public SensorEvent {
=======
        class WT_EXPORT_API HeadingEvent : public SensorEvent {
>>>>>>> 7a80d517418492d323a2b0529e1da11bec307318
        public:
            HeadingEvent(HeadingData heading_);

            const HeadingData& getHeadingData() const;

        private:
            HeadingData     _heading;
        };
    }
    using impl::SensorEvent;
    using impl::DeviceMotionData;
    using impl::AccelerationData;
    using impl::HeadingData;
    using impl::DeviceRotationEvent;
    using impl::DeviceOrientationEvent;
    using impl::AccelerationEvent;
    using impl::HeadingEvent;
}}

#endif /* __cplusplus */

#endif /* defined(SensorEvent_hpp) */
