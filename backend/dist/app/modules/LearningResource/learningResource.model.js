"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LearningResource = void 0;
const mongoose_1 = require("mongoose");
const learningResourceSchema = new mongoose_1.Schema({
    title: {
        type: String,
        required: [true, "Resource title is required"],
        trim: true,
    },
    platform: {
        type: String,
        required: [true, "Platform is required"],
        trim: true,
    },
    url: {
        type: String,
        required: [true, "URL is required"],
        trim: true,
    },
    relatedSkills: {
        type: [String],
        required: [true, "Related skills are required"],
        validate: {
            validator: (arr) => arr.length > 0,
            message: "At least one related skill is required",
        },
    },
    cost: {
        type: String,
        required: [true, "Cost is required"],
        enum: ["Free", "Paid"],
    },
    description: {
        type: String,
        trim: true,
    },
    duration: {
        type: String,
        trim: true,
    },
    careerTrack: {
        type: String,
        enum: [
            "Web Development",
            "Data",
            "Design",
            "Marketing",
            "Cybersecurity",
            "AI/ML",
            "Mobile App",
            "Other",
        ],
    },
}, {
    timestamps: true, // adds createdAt and updatedAt
});
exports.LearningResource = (0, mongoose_1.model)("LearningResource", learningResourceSchema);
