#NEW NICHEMPAR MODEL SETUP - USE THIS SCRIPT

endoR_devel <- function(
  TA = 20, # air temperature at local height (�C)
  TAREF = TA, # air temperature at reference height (�C)
  TGRD = TA, # ground temperature (�C)
  TSKY = TA, # sky temperature (�C)
  VEL = 0.1, # wind speed (m/s)
  RH = 5, # relative humidity (%)
  QSOLR = 0, # solar radiation, horizontal plane (W/m2)
  Z = 20, # zenith angle of sun (degrees from overhead)
  ELEV = 0, # elevation (m)
  ABSSB = 0.8, # solar absorptivity of substrate (fractional, 0-1)
  
  # other environmental variables
  FLTYPE = 0, # fluid type: 0 = air; 1 = fresh water; 2 = salt water
  TCONDSB = TGRD, # surface temperature for conduction (�C)
  KSUB = 2.79, # substrate thermal conductivity (W/m�C)
  TBUSH = TA, # bush temperature (�C)
  BP = -1, # Pa, negative means elevation is used
  O2GAS = 20.95, # oxygen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
  N2GAS = 79.02, # nitrogen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
  CO2GAS = 0.0412, # carbon dioxide concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
  R_PCO2 = CO2GAS / 100, # reference atmospheric dioxide concentration of air (proportion), to allow for anthropogenic change (\%)}\cr\cr
  PDIF = 0.15, # proportion of solar radiation that is diffuse (fractional, 0-1)
  
  # BEHAVIOUR
  
  SHADE = 0, # shade level (%)
  FLYHR = 0, # is flight occurring this hour? (imposes forced evaporative loss)
  UNCURL = 0.1, # allows the animal to uncurl to SHAPE_B_MAX, the value being the increment SHAPE_B is increased per iteration
  TC_INC = 0.1, # turns on core temperature elevation, the value being the increment by which TC is increased per iteration
  PCTWET_INC = 0.1, # turns on sweating, the value being the increment by which PCTWET is increased per iteration
  PCTWET_MAX = 100, # maximum surface area that can be wet (%)
  AK1_INC = 0.1, # turns on thermal conductivity increase (W/mK), the value being the increment by which AK1 is increased per iteration
  AK1_MAX = 2.8, # maximum flesh conductivity (W/mK)
  PANT = 1, # multiplier on breathing rate to simulate panting (-)
  PANT_INC = 0.1, # increment for multiplier on breathing rate to simulate panting (-)
  PANT_MULT = 1.05, # multiplier on basal metabolic rate at maximum panting level (-)}\cr\cr
  
  # MORPHOLOGY
  
  # geometry
  AMASS = 65, # kg
  ANDENS = 1000, # kg/m3
  SUBQFAT = 0, # is subcutaneous fat present? (0 is no, 1 is yes)
  FATPCT = 20, # % body fat
  SHAPE = 4, # shape, 1 is cylinder, 2 is sphere, 3 is plate, 4 is ellipsoid
  SHAPE_B = 1.1, # current ratio between long and short axis, must be > 1 (-)
  SHAPE_B_MAX = 5, # max possible ratio between long and short axis, must be > 1 (-)
  SHAPE_C = SHAPE_B, # current ratio of length:height (plate)
  PVEN = 0.5, # fraction of surface area that is ventral fur (fractional, 0-1)
  PCOND = 0, # fraction of surface area that is touching the substrate (fractional, 0-1)
  SAMODE = 0, # if 0, uses surface area for SHAPE parameter geometry, if 1, uses bird skin surface area allometry from Walsberg & King. 1978. JEB 76:185-189, if 2 uses mammal surface area from Stahl 1967.J. App. Physiol. 22, 453-460.
  ORIENT = 0, # if 1 = normal to sun's rays (heat maximising), if 2 = parallel to sun's rays (heat minimising), 3 = vertical and changing with solar altitude, or 0 = average
  
  # fur properties
  FURTHRMK = 0, # user-specified fur thermal conductivity (W/mK), not used if 0
  DHAIRD = 30E-06, # hair diameter, dorsal (m)
  DHAIRV = 30E-06, # hair diameter, ventral (m)
  LHAIRD = 23.9E-03, # hair length, dorsal (m)
  LHAIRV = 23.9E-03, # hair length, ventral (m)
  ZFURD = 2E-03, # fur depth, dorsal (m)
  ZFURV = 2E-03, # fur depth, ventral (m)
  RHOD = 3000E+04, # hair density, dorsal (1/m2)
  RHOV = 3000E+04, # hair density, ventral (1/m2)
  REFLD = 0.2,  # fur reflectivity dorsal (fractional, 0-1)
  REFLV = 0.2,  # fur reflectivity ventral (fractional, 0-1)
  ZFURCOMP = ZFURV, # depth of compressed fur (for conduction) (m)
  KHAIR = 0.209, # hair thermal conductivity (W/m�C)
  XR = 1, # fractional depth of fur at which longwave radiation is exchanged (0-1)
  
  # radiation exchange
  EMISAN = 0.99, # animal emissivity (-)
  FABUSH = 0, # this is for veg below/around animal (at TALOC)
  FGDREF = 0.5, # reference configuration factor to ground
  FSKREF = 0.5, # configuration factor to sky
  
  # PHYSIOLOGY
  
  # thermal
  TC = 37, # core temperature (�C)
  TC_MAX = 39, # maximum core temperature (�C)
  AK1 = 0.9, # initial thermal conductivity of flesh (0.412 - 2.8 W/m�C)
  AK2 = 0.230, # conductivity of fat (W/mK)
  
  # evaporation
  PCTWET = 0.5, # part of the skin surface that is wet (%)
  FURWET = 0, # part of the fur/feathers that is wet after rain (%)
  PCTBAREVAP = 0, # surface area for evaporation that is skin, e.g. licking paws (%)
  PCTEYES = 0, # surface area made up by the eye (%) - make zero if sleeping
  DELTAR = 0, # offset between air temperature and breath (�C)
  RELXIT = 100, # relative humidity of exhaled air, %
  
  # metabolism/respiration
  QBASAL = (70 * AMASS ^ 0.75) * (4.185 / (24 * 3.6)), # basal heat generation (W) from Kleiber (1947)
  TIMACT = 1, # multiplier on metabolic rate for activity costs
  RQ = 0.80, # respiratory quotient (fractional, 0-1)
  EXTREF = 20, # O2 extraction efficiency (%)
  PANT_MAX = 5, # maximum breathing rate multiplier to simulate panting (-)
  Q10 = 2, # Q10 factor for adjusting BMR for TC
  
  # initial conditions
  TS = TC - 3, # skin temperature (�C)
  TFA = TA, # fur/air interface temperature (�C)
  
  # other model settings
  DIFTOL = 0.001, # tolerance for SIMULSOL
  THERMOREG = 1, # invoke thermoregulatory response
  RESPIRE = 1 # compute respiration and associated heat loss
){
  # check shape for problems
  if(SHAPE_B <= 1 & SHAPE == 4){
    SHAPE_B <- 1.01
    message("warning: SHAPE_B must be greater than 1 for ellipsoids, resetting to 1.01 \n")
  }
  if(SHAPE_B_MAX <= 1 & SHAPE == 4){
    SHAPE_B_MAX <- 1.01
    message("warning: SHAPE_B_MAX must be greater than 1 for ellipsoids, resetting to 1.01 \n")
  }
  if(SHAPE_B_MAX < SHAPE_B){
    message("warning: SHAPE_B_MAX must greater than than or equal to SHAPE_B, resetting to SHAPE_B \n")
    SHAPE_B_MAX <- SHAPE_B
  }
  
  if(PANT_INC == 0){
    PANT_MAX <- PANT # can't pant, so panting level set to current value
  }
  if(PCTWET_INC == 0){
    PCTWET_MAX <- PCTWET # can't sweat, so max maximum skin wetness equal to current value
  }
  if(TC_INC == 0){
    TC_MAX <- TC # can't raise Tc, so max value set to current value
  }
  if(AK1_INC == 0){
    AK1_MAX <- AK1 # can't change thermal conductivity, so max value set to current value
  }
  if(UNCURL == 0){
    SHAPE_B_MAX <- SHAPE_B # can't change posture, so max multiplier of dimension set to current value
  }
  TSKINMAX <- TC # initialise
  Q10mult <- 1 # initialise
  PANT_COST <- 0 # initialise
  #PANTSTEP <- 0
  # check if heat stressed already (to save computation)
  ZFURD_REF <- ZFURD
  ZFURD <- LHAIRD
  ZFURV_REF <- ZFURV
  ZFURV <- LHAIRV
  QGEN <- 0
  TC_REF <- TC
  QBASREF <- QBASAL
  
  while(QGEN < QBASAL){
    
    ### IRPROP, infrared radiation properties of fur
    
    # call the IR properties subroutine
    IRPROP.out <- IRPROP((0.7 * TS + 0.3 * TFA), DHAIRD, DHAIRV, LHAIRD, LHAIRV, ZFURD, ZFURV, RHOD, RHOV, REFLD, REFLV, ZFURCOMP, PVEN, KHAIR)
    
    # output
    KEFARA <- IRPROP.out[1:3] # effective thermal conductivity of fur array, mean, dorsal, ventral (W/mK)
    BETARA <- IRPROP.out[4:6] # term involved in computing optical thickness (1/mK2)
    B1ARA <- IRPROP.out[7:9] # optical thickness array, mean, dorsal, ventral (m)
    DHAR <- IRPROP.out[10:12] # fur diameter array, mean, dorsal, ventral (m)
    LHAR <- IRPROP.out[13:15] # fur length array, mean, dorsal, ventral (m)
    RHOAR <- IRPROP.out[16:18] # fur density array, mean, dorsal, ventral (1/m2)
    ZZFUR <- IRPROP.out[19:21] # fur depth array, mean, dorsal, ventral (m)
    REFLFR <- IRPROP.out[22:24] # fur reflectivity array, mean, dorsal, ventral (fractional, 0-1)
    FURTST <- IRPROP.out[25] # test of presence of fur (length x diameter x density x depth) (-)
    KFURCMPRS <- IRPROP.out[26] # effective thermal conductivity of compressed ventral fur (W/mK)
    
    ### GEOM, geometry
    
    # input
    DHARA <- DHAR[1] # fur diameter, mean (m) (from IRPROP)
    RHOARA <- RHOAR[1] # hair density, mean (1/m2) (from IRPROP)
    ZFUR <- ZZFUR[1] # fur depth, mean (m) (from IRPROP)
    
    # call the subroutine
    GEOM.out <- GEOM_ENDO(AMASS, ANDENS, FATPCT, SHAPE, ZFUR, SUBQFAT, SHAPE_B, SHAPE_C, DHARA, RHOARA, PCOND, SAMODE, ORIENT, Z)
    
    # output
    VOL <- GEOM.out[1] # volume, m3
    D <- GEOM.out[2] # characteristic dimension for convection, m
    MASFAT <- GEOM.out[3] # mass body fat, kg
    VOLFAT <- GEOM.out[4] # volume body fat, m3
    ALENTH <- GEOM.out[5] # length, m
    AWIDTH <- GEOM.out[6] # width, m
    AHEIT <- GEOM.out[7] # height, m
    ATOT <- GEOM.out[8] # total area at fur/feathers-air interface, m2
    ASIL <- GEOM.out[9] # silhouette area to use in solar calcs, m2 may be normal, parallel or average set via ORIENT
    ASILN <- GEOM.out[10] # silhouette area normal to sun, m2
    ASILP <- GEOM.out[11] # silhouette area parallel to sun, m2
    GMASS <- GEOM.out[12] # mass, g
    AREASKIN <- GEOM.out[13] # area of skin, m2
    FLSHVL <- GEOM.out[14] # flesh volume, m3
    FATTHK <- GEOM.out[15] # fat layer thickness, m
    ASEMAJ <- GEOM.out[16] # semimajor axis length, m
    BSEMIN <- GEOM.out[17] # b semiminor axis length, m
    CSEMIN <- GEOM.out[18] # c semiminor axis length, m (currently only prolate spheroid)
    CONVSK <- GEOM.out[19] # area of skin for evaporation (total skin area - hair area), m2
    CONVAR <- GEOM.out[20] # area for convection (total area minus ventral area, as determined by PCOND), m2
    R1 <- GEOM.out[21] # shape-specific core-skin radius in shortest dimension, m
    R2 <- GEOM.out[22] # shape-specific core-fur radius in shortest dimension, m
    
    ### SOLAR, solar radiation
    
    # solar radiation normal to sun's rays
    ZEN <- pi/180*Z # convert degrees to radians
    if(Z < 90){ # compute solar radiation on a surface normal to the direct rays of the sun
      CZ <- cos(ZEN)
      QNORM <- QSOLR / CZ
    }else{ # diffuse skylight only
      QNORM <- QSOLR
    }
    
    ABSAND <- 1 - REFLFR[2] # solar absorptivity of dorsal fur (fractional, 0-1)
    ABSANV <- 1 - REFLFR[3] # solar absorptivity of ventral fur (fractional, 0-1)
    
    # correct FASKY for % vegetation shade overhead
    FAVEG <- FSKREF * (SHADE / 100)
    FASKY <- FSKREF - FAVEG
    FAGRD <- FGDREF
    
    SOLAR.out <- SOLAR_ENDO(ATOT, ABSAND, ABSANV, ABSSB, ASIL, PDIF, QNORM, SHADE,
                            QSOLR, FASKY, FAVEG)
    
    QSOLAR <- SOLAR.out[1] # total (global) solar radiation (W) QSOLAR,QSDIR,QSSKY,QSRSB,QSDIFF,QDORSL,QVENTR
    QSDIR <- SOLAR.out[2] # direct solar radiaton (W)
    QSSKY <- SOLAR.out[3] # diffuse solar radiation from sky (W)
    QSRSB <- SOLAR.out[4] # diffuse solar radiation reflected from substrate (W)
    QSDIFF <- SOLAR.out[5] # total diffuse solar radiation (W)
    QDORSL <- SOLAR.out[6] # total dorsal solar radiation (W)
    QVENTR <- SOLAR.out[7] # total ventral solar radiaton (W)
    
    ### CONV, convection
    
    # input
    SURFAR <- CONVAR # surface area for convection, m2 (from GEOM)
    TENV <- TA # fluid temperature (�C)
    
    # run subroutine
    CONV.out <- CONV_ENDO(TS, TENV, SHAPE, SURFAR, FLTYPE, FURTST, D, TFA, VEL, ZFUR, BP, ELEV)
    
    QCONV <- CONV.out[1] # convective heat loss (W)
    HC <- CONV.out[2] # combined convection coefficient
    HCFREE <- CONV.out[3] # free convection coefficient
    HCFOR <- CONV.out[4] # forced convection coefficient
    HD <- CONV.out[5] # mass transfer coefficient
    HDFREE <- CONV.out[6] # free mass transfer coefficient
    HDFORC <- CONV.out[7] # forced mass transfer coefficient
    ANU <- CONV.out[8] # Nusselt number (-)
    RE <- CONV.out[9] # Reynold's number (-)
    GR <- CONV.out[10] # Grasshof number (-)
    PR <- CONV.out[11] # Prandlt number (-)
    RA <- CONV.out[12] # Rayleigh number (-)
    SC <- CONV.out[13] # Schmidt number (-)
    BP <- CONV.out[14] # barometric pressure (Pa)
    
    # reference configuration factors
    FABUSHREF <- FABUSH # nearby bush
    FASKYREF <- FASKY # sky
    FAGRDREF <- FAGRD # ground
    FAVEGREF <- FAVEG # vegetation
    
    ### SIMULSOL, simultaneous solution of heat balance
    # repeat for each side, dorsal and ventral, of the animal
    SIMULSOL.out <- matrix(data = 0, nrow = 2, ncol = 15) # vector to hold the SIMULSOL results for dorsal and ventral side
    
    for(S in 1:2){
      
      # set infrared environment
      TVEG <- TAREF # assume vegetation casting shade is at reference (e.g. 1.2m or 2m) air temperature (�C)
      TLOWER <- TGRD
      # Calculating solar intensity entering fur. This will depend on whether we are calculating the fur temperature for the dorsal side or the ventral side. The dorsal side will have solar inputs from the direct beam hitting the silhouette area as well as diffuse solar scattered from the sky. The ventral side will have diffuse solar scattered off the substrate.
      # Resetting config factors and solar depending on whether the dorsal side (S=1) or ventral side (S=2) is being estimated.
      if(QSOLAR > 0.0){
        if(S == 1){
          FASKY <- FASKYREF /(FASKYREF + FAVEGREF) # proportion of upward view that is sky
          FAVEG <- FAVEGREF / (FASKYREF + FAVEGREF) # proportion of upward view that is vegetation (shade)
          FAGRD <- 0.0
          FABUSH <- 0.0
          QSLR <- 2 * QSDIR + ((QSSKY / FASKYREF) * FASKY) # direct x 2 because assuming sun in both directions, and unadjusting QSSKY for config factor imposed in SOLAR_ENDO and back to new larger one in both directions
        }else{  # doing ventral side. NB edit - adjust QSLR for PCOND here.
          FASKY <- 0.0
          FAVEG <- 0.0
          FAGRD <- FAGRDREF / (FAGRDREF + FABUSHREF)
          FABUSH <- FABUSHREF / (FAGRDREF + FABUSHREF)
          QSLR <- (QVENTR / (1 - FASKYREF - FAVEGREF)) * (1 - (2 * PCOND)) # unadjust by config factor imposed in SOLAR_ENDO to have it coming in both directions, but also cutting down according to fractional area conducting to ground (in both directions)
        }
      }else{
        QSLR <- 0.0
        if(S==1){
          FASKY <- FASKYREF / (FASKYREF + FAVEGREF)
          FAVEG <- FAVEGREF / (FASKYREF + FAVEGREF)
          FAGRD <- 0.0
          FABUSH <- 0.0
        }else{
          FASKY <- 0.0
          FAVEG <- 0.0
          FAGRD <- FAGRDREF / (FAGRDREF + FABUSHREF)
          FABUSH <- FABUSHREF / (FAGRDREF + FABUSHREF)
        }
      }
      
      # set fur depth and conductivity
      # index for KEFARA, the conductivity, is the average (1), front/dorsal (2), back/ventral(3) of the body part
      if(QSOLR > 0 | ZZFUR[2] != ZZFUR[3]){
        if(S == 1){
          ZL <- ZZFUR[2]
          KEFF <- KEFARA[2]
        }else{
          ZL <- ZZFUR[3]
          KEFF <- KEFARA[3]
        }
      }else{
        ZL <- ZZFUR[1]
        KEFF <- KEFARA[1]
      }
      
      RSKIN <- R1 # body radius (including fat), m
      RFLESH <- R1 - FATTHK # body radius flesh only (no fat), m
      RFUR <- R1 + ZL # body radius including fur, m
      D <- 2 * RFUR # diameter, m
      RRAD <- RSKIN + (XR * ZL) # effective radiation radius, m
      LEN <- ALENTH # length, m
      
      if(SHAPE != 4){ #! For cylinder and sphere geometries
        RFURCMP <- RSKIN + ZFURCOMP
      }else{
        RFURCMP <- RFUR #! Note that this value is never used if conduction not being modeled, but need to have a value for the calculations
      }
      
      if(SHAPE == 4){  #! For ellipsoid geometry
        BLCMP <- BSEMIN + ZFURCOMP
      }else{
        BLCMP <- RFUR #! Note that this value is never used if conduction not being modeled, but need to have a value for the calculations
      }
      
      # Correcting volume to account for subcutaneous fat
      if(SUBQFAT == 1 & FATTHK > 0.0){
        VOL <- FLSHVL
      }
      
      # Calculating the "Cd" variable: Qcond = Cd(Tskin-Tsub), where Cd = Conduction area*ksub/subdepth
      if(S == 2){
        AREACND <- ATOT * PCOND * 2
        CD <- AREACND * KSUB / 0.025 # assume conduction happens from 2.5 cm depth
      }else{ #doing dorsal side, no conduction. No need to adjust areas used for convection.
        AREACND <- 0
        CD <- 0
      }
      
      # package up inputs
      FURVARS <- c(LEN,ZFUR,FURTHRMK,KEFF,BETARA,FURTST,ZL,LHAR[S+1],DHAR[S+1],RHOAR[S+1],REFLFR[S+1],KHAIR,S)
      GEOMVARS <- c(SHAPE,SUBQFAT,CONVAR,VOL,D,CONVAR,CONVSK,RFUR,RFLESH,RSKIN,XR,RRAD,ASEMAJ,BSEMIN,CSEMIN,CD,PCOND,RFURCMP,BLCMP,KFURCMPRS)
      ENVVARS <- c(FLTYPE,TA,TS,TBUSH,TVEG,TLOWER,TSKY,TCONDSB,RH,VEL,BP,ELEV,FASKY,FABUSH,FAVEG,FAGRD,QSLR)
      TRAITS <- c(TC,AK1,AK2,EMISAN,FATTHK,FLYHR,FURWET,PCTBAREVAP,PCTEYES)
      
      # set IPT, the geometry assumed in SIMULSOL: 1 = cylinder, 2 = sphere, 3 = ellipsoid
      if(SHAPE %in% c(1, 3)){
        IPT <- 1
      }
      if(SHAPE == 2){
        IPT <- 2
      }
      if(SHAPE == 4){
        IPT <- 3
      }
      
      # call SIMULSOL
      SIMULSOL.out[S,] <- SIMULSOL(DIFTOL, IPT, FURVARS, GEOMVARS, ENVVARS, TRAITS, TFA, PCTWET, TS)
    }
    TSKINMAX <- max(SIMULSOL.out[1,2], SIMULSOL.out[2,2])
    
    ### ZBRENT and RESPFUN
    
    # Now compute a weighted mean heat generation for all the parts/components = (dorsal value *(FASKY+FAVEG))+(ventral value*FAGRD)
    GEND <- SIMULSOL.out[1, 5]
    GENV <- SIMULSOL.out[2, 5]
    DMULT <- FASKYREF + FAVEGREF
    VMULT <- 1 - DMULT # assume that reflectivity of veg below = ref of soil so VMULT left as 1 - DMULT
    X <- GEND * DMULT + GENV * VMULT # weighted estimate of metabolic heat generation
    QSUM <- X
    
    # reset configuration factors
    FABUSH <- FABUSHREF # nearby bush
    FASKY <- FASKYREF # sky
    FAGRD <- FAGRDREF # ground
    FAVEG <- FAVEGREF # vegetation
    
    # lung temperature and temperature of exhaled air
    TS <- (SIMULSOL.out[1, 2] + SIMULSOL.out[2, 2]) * 0.5
    TFA <- (SIMULSOL.out[1, 1] + SIMULSOL.out[2, 1]) * 0.5
    TLUNG <- (TC + TS) * 0.5 # average of skin and core
    TAEXIT <- min(TA + DELTAR, TLUNG) # temperature of exhaled air, �C
    
    if(RESPIRE == 1){
      # now guess for metabolic rate that balances the heat budget while allowing metabolic rate
      # to remain at or above QBASAL, via 'shooting method' ZBRENT
      QMIN <- QBASAL
      if(TA < TC & TSKINMAX < TC){
        QM1 <- QBASAL * 2 * -1
        QM2 <- QBASAL * 50
      }else{
        QM1 <- QBASAL * 50* -1
        QM2 <- QBASAL * 2
      }
      TOL <- AMASS * 0.01
      
      ZBRENT.in <- c(TA, O2GAS, N2GAS, CO2GAS, BP, QMIN, RQ, TLUNG, GMASS, EXTREF, RH,
                     RELXIT, TIMACT, TAEXIT, QSUM, PANT, R_PCO2)
      # call ZBRENT subroutine which calls RESPFUN
      ZBRENT.out <- ZBRENT_ENDO(QM1, QM2, TOL, ZBRENT.in)
      colnames(ZBRENT.out) <- c("RESPFN","QRESP","GEVAP", "PCTO2", "PCTN2", "PCTCO2", "RESPGEN", "O2STP", "O2MOL1", "N2MOL1", "AIRML1", "O2MOL2", "N2MOL2", "AIRML2", "AIRVOL")
      QGEN <- ZBRENT.out[7] # Q_GEN,NET
    }else{
      QGEN <- QSUM
      ZBRENT.out <- matrix(data = 0, nrow = 1, ncol = 15)
      colnames(ZBRENT.out) <- c("RESPFN","QRESP","GEVAP", "PCTO2", "PCTN2", "PCTCO2", "RESPGEN", "O2STP", "O2MOL1", "N2MOL1", "AIRML1", "O2MOL2", "N2MOL2", "AIRML2", "AIRVOL")
    }
    SHAPE_B_LAST <- SHAPE_B
    AK1_LAST <- AK1
    TC_LAST <- TC
    PANT_LAST <- PANT
    PCTWET_LAST <- PCTWET
    if(THERMOREG != 0){
      if(ZFURD > ZFURD_REF & ZFURV > ZFURV_REF){
        ZFURD <- ZFURD - ZFUR_INC
        ZFURV <- ZFURV - ZFUR_INC
      }else{
        ZFURD <- ZFURD_REF
        ZFURV <- ZFURV_REF
        if(SHAPE_B < SHAPE_B_MAX){
          SHAPE_B <- SHAPE_B + UNCURL
        }else{
          SHAPE_B <- SHAPE_B_MAX
          if(AK1 < AK1_MAX){
            AK1 <- AK1 + AK1_INC
          }else{
            AK1 <- AK1_MAX
            if(TC < TC_MAX & PANT < PANT_MAX){
              TC <- TC + TC_INC
              Q10mult <- Q10^((TC - TC_REF)/10)
              QBASAL = QBASREF * Q10mult
              PANT <- PANT + PANT_INC
              PANTCOST <- ((PANT - 1) / (PANT_MAX - 1) * (PANT_MULT - 1) * QBASREF)
              QBASAL <- QBASREF * Q10mult + PANTCOST
            }else{
              TC <- TC_MAX
              Q10mult <- Q10^((TC - TC_REF)/10)
              PANT <- PANT_MAX
              PANTCOST <- ((PANT - 1) / (PANT_MAX - 1) * (PANT_MULT - 1) * QBASREF)
              QBASAL <- QBASREF * Q10mult + PANTCOST
              PCTWET <- PCTWET + PCTWET_INC
              if(PCTWET > PCTWET_MAX | PCTWET_INC == 0){
                PCTWET <- PCTWET_MAX
                break
              }
            }
          }
        }
      }
    }
  }
  # SIMULSOL output, dorsal
  TFA.D <- SIMULSOL.out[1, 1] # temperature of feathers/fur-air interface, deg C
  TSKCALCAV.D <- SIMULSOL.out[1, 2] # average skin temperature, deg C
  QCONV.D <- SIMULSOL.out[1, 3] # convection, W
  QCOND.D <- SIMULSOL.out[1, 4] # conduction, W
  QGENNET.D <- SIMULSOL.out[1, 5] # heat generation from flesh, W
  QSEVAP.D <- SIMULSOL.out[1, 6] # cutaneous evaporative heat loss, W
  QRAD.D <- SIMULSOL.out[1, 7] # radiation lost at fur/feathers/bare skin, W
  QSLR.D <- SIMULSOL.out[1, 8] # solar radiation, W
  QRSKY.D <- SIMULSOL.out[1, 9] # sky radiation, W
  QRBSH.D <- SIMULSOL.out[1, 10] # bush/object radiation, W
  QRVEG.D <- SIMULSOL.out[1, 11] # overhead vegetation radiation (shade), W
  QRGRD.D <- SIMULSOL.out[1, 12] # ground radiation, W
  QFSEVAP.D <- SIMULSOL.out[1, 13] # fur evaporative heat loss, W
  NTRY.D <- SIMULSOL.out[1, 14] # solution attempts, #
  SUCCESS.D <- SIMULSOL.out[1, 15] # successful solution found? (0 no, 1 yes)
  
  # SIMULSOL output, ventral
  TFA.V <- SIMULSOL.out[2, 1] # temperature of feathers/fur-air interface, deg C
  TSKCALCAV.V <- SIMULSOL.out[2, 2] # average skin temperature, deg C
  QCONV.V <- SIMULSOL.out[2, 3] # convection, W
  QCOND.V <- SIMULSOL.out[2, 4] # conduction, W
  QGENNET.V <- SIMULSOL.out[2, 5] # heat generation from flesh, W
  QSEVAP.V <- SIMULSOL.out[2, 6] # cutaneous evaporative heat loss, W
  QRAD.V <- SIMULSOL.out[2, 7] # radiation lost at fur/feathers/bare skin, W
  QSLR.V <- SIMULSOL.out[2, 8] # solar radiation, W
  QRSKY.V <- SIMULSOL.out[2, 9] # sky radiation, W
  QRBSH.V <- SIMULSOL.out[2, 10] # bush/object radiation, W
  QRVEG.V <- SIMULSOL.out[2, 11] # overhead vegetation radiation (shade), W
  QRGRD.V <- SIMULSOL.out[2, 12] # ground radiation, W
  QFSEVAP.V <- SIMULSOL.out[2, 13] # fur evaporative heat loss, W
  NTRY.V <- SIMULSOL.out[2, 14] # solution attempts, #
  SUCCESS.V <- SIMULSOL.out[2, 15] # successful solution found? (0 no, 1 yes)
  
  RESPFN <- ZBRENT.out[1] # heat sum (should be near zero), W
  QRESP <- ZBRENT.out[2] # respiratory heat loss, W
  GEVAP <- ZBRENT.out[3] # respiratory evaporation (g/s)
  PCTO2 <- ZBRENT.out[4] # O2 concentration (%)
  PCTN2 <- ZBRENT.out[5] # N2 concentration (%)
  PCTCO2 <- ZBRENT.out[6] # CO2 concentration (%)
  RESPGEN <- ZBRENT.out[7] # metabolic heat (W)
  O2STP <- ZBRENT.out[8] # O2 in rate at STP (L/s)
  O2MOL1 <- ZBRENT.out[9] # O2 in (mol/s)
  N2MOL1 <- ZBRENT.out[10] # N2 in (mol/s)
  AIRML1 <- ZBRENT.out[11] # air in (mol/s)
  O2MOL2 <- ZBRENT.out[12] # O2 out (mol/s)
  N2MOL2 <- ZBRENT.out[13] # N2 out (mol/s)
  AIRML2 <- ZBRENT.out[14] # air out (mol/s)
  AIRVOL <- ZBRENT.out[15] # air out at STP (L/s)
  
  HTOVPR <- 2.5012E+06 - 2.3787E+03 * TA # latent heat of vapourisation, W/kg/C
  SWEAT.G.S <- (QSEVAP.D + QSEVAP.V) * 0.5 / HTOVPR * 1000 # water lost from skin, g/s
  EVAP.G.S <- GEVAP + SWEAT.G.S # total evaporative water loss, g/s
  sigma <- 5.6697E-8
  QIROUT.D <- sigma * EMISAN * AREASKIN * (TSKCALCAV.D + 273.15) ^ 4
  QIRIN.D <- QRAD.D * -1 + QIROUT.D
  QIROUT.V <- sigma * EMISAN * AREASKIN * (TSKCALCAV.D + 273.15) ^ 4
  QIRIN.V <- QRAD.V * -1 + QIROUT.V
  
  QSOL <- QSLR.D * DMULT + QSLR.V * VMULT # solar, W
  QIRIN <- QIRIN.D * DMULT + QIRIN.V * VMULT # infrared in, W
  if(RESPIRE == 1){
    QGEN <- RESPGEN # metabolism, W
  }else{
    QGEN <- QSUM
  }
  QEVAP <- QSEVAP.D * DMULT + QSEVAP.V * VMULT + QFSEVAP.D * DMULT + QFSEVAP.V * VMULT + QRESP # evaporation, W
  QIROUT <- QIROUT.D * DMULT + QIROUT.V * VMULT # infrared out, W
  QCONV <- QCONV.D * DMULT + QCONV.V * VMULT # convection, W
  QCOND <- QCOND.D * DMULT + QCOND.V * VMULT # conduction, W
  
  treg1 <- c(TC_LAST, TLUNG, TSKCALCAV.D, TSKCALCAV.V, TFA.D, TFA.V, SHAPE_B_LAST, PANT_LAST, PCTWET_LAST, AK1_LAST, KEFARA[1], KEFARA[2], KEFARA[3], KFURCMPRS, Q10mult)
  morph1 <- c(ATOT, VOL, D, MASFAT, FATTHK, FLSHVL, ALENTH, AWIDTH, AHEIT, R1, R2, ASIL, ASILN, ASILP, AREASKIN, CONVSK, CONVAR, AREACND / 2, FASKY, FAGRD)
  enbal1 <- c(QSOL, QIRIN, QGEN, QEVAP, QIROUT, QCONV, QCOND, RESPFN, max(NTRY.D, NTRY.V), min(SUCCESS.D, SUCCESS.V))
  masbal1 <- c(AIRVOL, O2STP, GEVAP, SWEAT.G.S, O2MOL1, O2MOL2, N2MOL1, N2MOL2, AIRML1, AIRML2) * 3600
  
  treg <- matrix(data = treg1, nrow = 1, ncol = 15)
  morph <- matrix(data = morph1, nrow = 1, ncol = 20)
  masbal <- matrix(data = masbal1, nrow = 1, ncol = 10)
  enbal <- matrix(data = enbal1, nrow = 1, ncol = 10)
  
  treg.names <- c("TC", "TLUNG", "TSKIN_D", "TSKIN_V", "TFA_D", "TFA_V", "SHAPE_B", "PANT", "PCTWET", "K_FLESH", "K_FUR", "K_FUR_D", "K_FUR_V", "K_COMPFUR", "Q10")
  morph.names <- c("AREA", "VOLUME", "CHAR_DIM", "MASS_FAT", "FAT_THICK", "FLESH_VOL", "LENGTH", "WIDTH", "HEIGHT", "DIAM_FLESH", "DIAM_FUR", "AREA_SIL", "AREA_SILN", "AREA_ASILP", "AREA_SKIN", "AREA_SKIN_EVAP", "AREA_CONV", "AREA_COND", "F_SKY", "F_GROUND")
  enbal.names <- c("QSOL", "QIRIN", "QGEN", "QEVAP", "QIROUT", "QCONV", "QCOND", "ENB", "NTRY", "SUCCESS")
  masbal.names <- c("AIR_L", "O2_L", "H2OResp_g", "H2OCut_g", "O2_mol_in", "O2_mol_out", "N2_mol_in", "N2_mol_out", "AIR_mol_in", "AIR_mol_out")
  colnames(treg) <- treg.names
  colnames(morph) <- morph.names
  colnames(enbal) <- enbal.names
  colnames(masbal) <- masbal.names
  
  if(max(treg) == 0){
    warning("A solution could not be found and panting/'sweating' options are exhausted; try allowing greater evaporation or allowing higher body maximum body temperature")
  }
  endo.out <- list(treg = treg, morph = morph, enbal = enbal, masbal = masbal)
  return(endo.out)
}