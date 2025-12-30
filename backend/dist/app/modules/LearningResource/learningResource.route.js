"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LearningResourceRoutes = void 0;
const express_1 = __importDefault(require("express"));
const learningResourece_controller_1 = require("./learningResourece.controller");
const router = express_1.default.Router();
router.post("/", learningResourece_controller_1.LearningResourceController.createLearningResource);
router.get("/", learningResourece_controller_1.LearningResourceController.getAllLearningResources);
router.get("/:id", learningResourece_controller_1.LearningResourceController.getSingleLearningResource);
router.patch("/:id", learningResourece_controller_1.LearningResourceController.updateLearningResource);
router.delete("/:id", learningResourece_controller_1.LearningResourceController.deleteLearningResource);
exports.LearningResourceRoutes = router;
