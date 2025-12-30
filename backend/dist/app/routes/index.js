"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const user_route_1 = require("../modules/User/user.route");
const auth_route_1 = require("../modules/Auth/auth.route");
const job_route_1 = require("../modules/Jobs/job.route");
const learningResource_route_1 = require("../modules/LearningResource/learningResource.route");
// import { chatRoutes } from '../modules/Chat/chat.route';
const router = (0, express_1.Router)();
const moduleRoutes = [
    {
        path: '/users',
        route: user_route_1.userRoutes,
    },
    {
        path: '/auth',
        route: auth_route_1.AuthRoutes,
    },
    {
        path: '/jobs',
        route: job_route_1.jobRoutes,
    },
    {
        path: '/learning-resources',
        route: learningResource_route_1.LearningResourceRoutes
    },
];
moduleRoutes.forEach((route) => router.use(route.path, route.route));
exports.default = router;
